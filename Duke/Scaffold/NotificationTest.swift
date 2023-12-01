//
//  NotificationTest.swift
//  Duke
//
//  Created by user226714 on 10/29/23.
//

import SwiftUI

@available(iOS 16.0, *)
struct NotificationTest: View {
    @State private var showSheet: Bool = false

        var body: some View {
            NavigationStack {
                VStack {
                    Button("show Sheet") {
                        showSheet.toggle()
                    }
                    .sheet(isPresented: $showSheet, content: {
                        Button("Show AirDrop Notification") {
                            UIApplication.shared.inAppNotification(adaptForDynamicIsland: true, timeout: 5, swipeToClose: true) {
                                HStack {
                                    Image(systemName: "wifi")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.white)

                                    VStack(alignment: .leading, spacing: 2, content: {
                                        Text("AirDrop")
                                        .font(.caption.bold())
                                        .foregroundStyle(.white)

                                        Text("From iJustine")
                                        .foregroundStyle(.gray)
                                    })
                                    .padding(.top, 20)

                                    Spacer(minLength: 0)
                                }
                                .padding(15)
                                .background (
                                    RoundedRectangle(cornerRadius: 15)
                                    .fill(.black)
                                )
                            }
                        }
                        .buttonStyle(.bordered)
                        .buttonBorderShape(.roundedRectangle(radius: 10))
                        .tint(.red)
                    })

                    Button("show notification") {
                        UIApplication.shared.inAppNotification(adaptForDynamicIsland: true, timeout: 5, swipeToClose: true) {
                            HStack {
                                Image("pic")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())

                                VStack(alignment: .leading, spacing: 6, content: {
                                    Text("iJustine")
                                    .font(.caption.bold())
                                    .foregroundStyle(.white)

                                    Text("Hello, this is iJustine")
                                    .foregroundStyle(.gray)
                                })
                                .padding(.top, 20)

                                Spacer(minLength: 0)

                                Button(action: {},  label: {
                                    Image(systemName: "speaker.slash.fill")
                                    .font(.title2)
                                })
                                .buttonStyle(.bordered)
                                .buttonBorderShape(.roundedRectangle)
                                .tint(.white)
                            }
                            .padding(15)
                            .background (
                                RoundedRectangle(cornerRadius: 15)
                                .fill(.black)
                            )
                        }
                    }
                }
                .navigationTitle("In App Notifications")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
}

@available(iOS 16.0, *)
struct NotificationTest_Previews: PreviewProvider {
    static var previews: some View {
        NotificationTest()
    }
}

@available(iOS 16.0, *)
extension UIApplication {
    func inAppNotification<Content: View>(adaptForDynamicIsland: Bool = true, timeout: CGFloat = 5, swipeToClose: Bool = true, @ViewBuilder content: @escaping () -> Content) {
        ///fetching active window via window scene
        if let activeWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: {$0.tag == 0320}) {
            ///frame and safe area values
            let frame = activeWindow.frame
            let safeArea = activeWindow.safeAreaInsets

            var tag: Int = 1009
            let checkForDynamicIsland = adaptForDynamicIsland && safeArea.top >= 51

            if let previousTag = UserDefaults.standard.value(forKey: "in_app_notification_tag") as? Int {
                tag = previousTag + 1
            }

            UserDefaults.standard.setValue(tag, forKey: "in_app_notification_tag")

            ///Changing Status into Black to blend with dynamic island
            if checkForDynamicIsland {
                if let controller = activeWindow.rootViewController as? StatusBarBasedController {
                    controller.statusBarStyle = .darkContent
                    controller.setNeedsStatusBarAppearanceUpdate()
                }
            }

            ///creating UIView from SwiftUIView using UIHosting Configuration
            let config = UIHostingConfiguration { //Starting with iOS 16, we can create a UIView from the SwiftUI View with the help of UIHostingConfiguration
                AnimatedNotificationView(content: content(), safeArea: safeArea, tag: tag, adaptForDynamicIsland: checkForDynamicIsland, timeout: timeout, swipeToClose: swipeToClose)
                .frame(width: frame.width - (checkForDynamicIsland ?  20 : 30), height: 120, alignment: .top)
                .contentShape(Rectangle())
            }

            //creating UIView
            let view = config.makeContentView()
            view.tag = tag
            view.backgroundColor = .clear
            view.translatesAutoresizingMaskIntoConstraints = false

            if let rootView = activeWindow.rootViewController?.view {
                ///adding view to the window
                rootView.addSubview(view)
                ///Layout Constraints
                view.centerXAnchor.constraint(equalTo: rootView.centerXAnchor).isActive = true
                view.centerYAnchor.constraint(equalTo: rootView.centerYAnchor, constant: (-(frame.height - safeArea.top) / 2) + (checkForDynamicIsland ? 11 : safeArea.top)).isActive = true
            }
            //since the overlay windows has been created in the apps LifeCycle, the preview wont create the overlay window, we will need to run it on simulator. If we need the preview to be working, we need to change the code from the apps LifeCycle to the ContentView,& the preview will work fine
        }
    }
}

@available(iOS 16.0, *)
fileprivate struct AnimatedNotificationView<Content: View>: View {
    var content: Content
    var safeArea: UIEdgeInsets
    var tag: Int
    var adaptForDynamicIsland: Bool
    var timeout: CGFloat
    var swipeToClose: Bool

    ///View properties
    @State private var animateNotification: Bool = false

    var body: some View {
        content
            .blur(radius: animateNotification ? 0 : 10)
        .disabled(!animateNotification)
        .mask {
            if adaptForDynamicIsland {
                //Size Based Capsule
                GeometryReader(content: { geometry in
                    let size = geometry.size
                    let radius = size.height / 2
                    
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                })
            } else {
                Rectangle()
            }
        }
        ///scaling animation only for dynamic island notification
        .scaleEffect(adaptForDynamicIsland ? (animateNotification ? 1 : 0.01) : 1, anchor: .init(x: 0.5, y: 0.01))
        ///offset animation for non dynamic island Notifications
        .offset(y: offsetY)
        .gesture(
            DragGesture()
            .onEnded({ value in
                if -value.translation.height > 50 && swipeToClose {
                    withAnimation(.spring()) {
                        animateNotification = false
                        removeNotificationViewFromWindow()
                    }
                }
            })
        )
        .onAppear(perform: {
            Task {
                guard !animateNotification else { return }
                withAnimation(.spring()) {
                    animateNotification = true
                }

                //timeout for notification. lImiting the timeout to a minimum of one second
                try await Task.sleep(for: .seconds(timeout < 1 ? 1 : timeout))

                guard animateNotification else { return } //the reason for that check is to verify that the notification is still active and not explicitly removed by the user
  
                withAnimation(.spring()) {
                    animateNotification = false
                    removeNotificationViewFromWindow()
                }
            }
        })
    }

    var offsetY: CGFloat {
        if adaptForDynamicIsland {
            return 0
        }

        return animateNotification ? 10 : -(safeArea.top + 130)
    }

    func removeNotificationViewFromWindow () {
        if let activeWindow = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first(where: {$0.tag == 0320}) {
            if let view = activeWindow.viewWithTag(tag) {
               // print("Removed View with \(tag)")
                view.removeFromSuperview()

                //Resetting once all notifications are removed
                if let controller = activeWindow.rootViewController as? StatusBarBasedController, controller.view.subviews.isEmpty {
                    controller.statusBarStyle = .default
                    controller.setNeedsStatusBarAppearanceUpdate()
                }
            }
        }
    }
}

