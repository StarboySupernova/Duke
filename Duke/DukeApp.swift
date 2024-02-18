//
//  DukeApp.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/2/22.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import Resolver

@main
struct DukeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var straddleScreen: StraddleScreen =  StraddleScreen()
    @StateObject var userViewModel: UserViewModel = UserViewModel()
    @StateObject var preferenceStore: UserPreference = UserPreference() //should not be initialized until afer user is logged in
    @StateObject var homeViewModel: HomeViewModel = HomeViewModel()
    @State private var overlayWindow : PassThroughWindow?

    init() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .black
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        UISearchBar.appearance().overrideUserInterfaceStyle = .dark
    }
    
    var body: some Scene {
        WindowGroup {
            ComplexContentView()
                .environmentObject(preferenceStore)
                .environmentObject(homeViewModel)
                .environmentObject(straddleScreen)
                .environmentObject(userViewModel)
//                .modifier(DarkModeViewModifier())
                .onAppear(perform: {
                    ///functionality to ensure sheet does not cover over notifications, so we create an overlay window which notifications will appear on, above the app's main window. This window will be a PassthroughWindow to allow interactions with the underlying window
                    if overlayWindow == nil {
                        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                            let overlayWindow = PassThroughWindow(windowScene: windowScene)
                            overlayWindow.backgroundColor = .clear
                            overlayWindow.tag = 0320
                            let controller = StatusBarBasedController()
                            controller.view.backgroundColor = .clear
                            overlayWindow.rootViewController = controller
                            overlayWindow.isHidden = false
                            overlayWindow.isUserInteractionEnabled = true
                            self.overlayWindow = overlayWindow
                            //print("Overlay Window Created")
                        }
                    }
                })
        }
    }
}

//MARK: Used more verbose Firebase setup to enable OTP phone authentication in future
class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all //By default we want all our views to rotate freely
    
    @Injected var authenticationService: AuthenticationService
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        #warning("temporary placement, anonymous sign in ought to be somewhere else not whenever app is lauched")
        authenticationService.signIn()
        UITabBar.appearance().isHidden = true //Tabs hidden, custom implementation will be shown
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //needed for phone Auth
    }
        
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}


class StatusBarBasedController: UIViewController {
    var statusBarStyle: UIStatusBarStyle = .default

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
}

fileprivate class PassThroughWindow: UIWindow {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        guard let view = super.hitTest(point, with: event) else { return nil }
        return rootViewController?.view == view ? nil: view
    }
}


