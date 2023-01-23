//
//  FavouritesHome.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/18/23.
//

import SwiftUI

struct FavouritesHome: View {
    //MARK: View Bounds
    var size: CGSize
    var safeArea : EdgeInsets
    //MARK: Gesture Values
    @State private var offsetY: CGFloat = 0
    @State private var currentCardIndex: CGFloat = 0
    // MARK: Animator State
    @StateObject var animator : Animator = .init()
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView()
                .overlay(alignment: .bottomTrailing, content: {
                    Button {
                        
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                            //.fontWeight(.semibold)
                            .foregroundColor(.gray)
                            .frame(width: .xxxLarge, height: .xxxLarge)
                            .background(
                                Ellipse()
                                    .fill(.white)
                                    .shadow(color: .black.opacity(0.35), radius: 5, x: 5, y: 5)
                            )
                    }
                    .offset(x: -.large, y: .large)
                    .offset(x: animator.startAnimation ? 80 : 0)
                })
                .zIndex(1)
            FavouritesCardView()
                .zIndex(0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            ZStack(alignment: .bottom) {
                ZStack {
                    if animator.showClouds {
                        Group {
                            //cloud views
                            CloudView(delay: 0.5, size: size)
                                .offset(y: size.height * -0.1)
                            
                            CloudView(delay: 0, size: size)
                                .offset(y: size.height * 0.3)
                            
                            CloudView(delay: 1, size: size)
                                .offset(y: size.height * 0.2)

                        }
                    }
                }
                .frame(maxHeight: .infinity)
                
                CloudView(delay: 1.25, size: size)
                
                if animator.showLoadingView {
                    RingBackgroundView()
                        .transition(.scale)
                        .opacity(animator.showFinalView ? 0 : 1)
                }
            }
        )
        .allowsHitTesting(!animator.showFinalView)
        .background(
            //safety check
            //if animator.startAnimation {} will not run
            PaymentDetailView(size: size, safeArea: safeArea)
                .environmentObject(animator)
        )
        .overlayPreferenceValue(RectKey.self, { value in
            if let anchor = value["HEADERBOUNDS"] {
                //using GeometryReader to extract a CGRect from anchor
                GeometryReader { geometry in
                    let rect = geometry[anchor]
                    let imageRect = animator.initialImagePostion
                    let status = animator.currentPaymentStatus
                    let animationStatus = status == .finished && !animator.showFinalView
                    
                    Image("favourite")
                        .resizedToFit(width: imageRect.width, height: imageRect.height)
                        .rotationEffect(.init(degrees: animationStatus ? -10 : 0)) //flight movement animation
                        .shadow(color: .black.opacity(0.25), radius: 1, x: animationStatus ? -400 : 0, y: animationStatus ? 170 : 0)
                        .offset(x: imageRect.minX, y: imageRect.minY)
                        .offset(y: animator.startAnimation ? 50 : 0)
                        .scaleEffect(animator.showFinalView ? 0.9 : 1)
                        .offset(y: animator.showFinalView ? 30 : 0)
                        .onAppear {
                            animator.initialImagePostion = rect
                        }
                        .animation(.easeInOut(duration: animationStatus ? 3.5 : 1.5), value: animationStatus)
                }
            }
        })
        .overlay(content: {
            if animator.showClouds {
                CloudView(delay: 1.2, size: size)
                    .offset(y: -size.height * 0.25)
            }
        })
        .background (
            
        )
        //simulating change to finished processing
        .onChange(of: animator.currentPaymentStatus) { newValue in
            if newValue == .finished {
                animator.showClouds = true
                
                //enabling final view
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        animator.showFinalView = true
                    }
                }
            }
        }
    }
    
    func makeBookingPurchase () {
        //animating content
        withAnimation(.easeInOut(duration: 0.1)) {
            animator.startAnimation = true
        }
        
        //showLoadingView after delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            withAnimation(.easeInOut(duration: 0.1)) {
                animator.showLoadingView = true
            }
        }
    }
    
    //MARK: Background View with ring animations
    @ViewBuilder func RingBackgroundView() -> some View {
        VStack {
            //Payment Status
            VStack(spacing: 0) {
                ForEach(PaymentStatus.allCases, id: \.rawValue){ status in
                    Text(status.rawValue)
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundColor(.gray.opacity(0.5))
                        .frame(height: .xxLarge)
                }
            }
            .offset(y: animator.currentPaymentStatus == .started ? -30 : animator.currentPaymentStatus == .finished ? -60 : 0)
            .frame(height: .xxLarge)
            .clipped()
            .zIndex(1)
            
            ZStack {
                //only appears in light mode
                /*Circle()
                    .fill(Color.offWhite)
                    .shadow(color: .white.opacity(0.45), radius: 5, x: 5, y: 5)
                    .shadow(color: .white.opacity(0.45), radius: 5, x: -5, y: -5)
                    .scaleEffect(2)*/
                
                Circle()
                    .fill(Color.black)
                    .shadow(color: .white.opacity(0.2), radius: 5, x: 5, y: 5)
                    .shadow(color: .white.opacity(0.2), radius: 5, x: -5, y: -5)
                    .scaleEffect(1.12) //is 1.22 in light mode
                
                Circle()
                    .fill(Color.offWhite)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 5, y: 5)
                
                Image(systemName: animator.currentPaymentStatus.symbolImage)
                    .font(.largeTitle)
                    .foregroundColor(.black.opacity(0.9))
            }
            .frame(width: 80, height: 80)
            .padding(.top, .xLarge)
            .zIndex(0)
        }
        //MARK: Using Timer to simulate loading process. Will replace with actual payment process, likely with Stripe
        .onReceive(Timer.publish(every: 2.3, on: .main, in: .common).autoconnect()) { _ in
            withAnimation(.easeInOut(duration: 0.3)) {
                if animator.currentPaymentStatus == .initiated {
                    animator.currentPaymentStatus = .started
                } else {
                    animator.currentPaymentStatus = .finished
                }
            }
        }
        .padding(.bottom, size.height * 0.15)
    }
    
    @ViewBuilder func HeaderView () -> some View {
        VStack {
            Image("pancakes")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width * 0.4)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack {
                #warning("create scroll like effect here")
                BookedVenueView(place: "The Icarus", code: "JHB", time: "17:30", categories: ["Greek", "Vegan"])
                
                VStack {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                    
                    Text("Next Order")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                
                BookedVenueView(alignment: .trailing, place: "Dionysius Cafe", code: "CPT", time: "14:30", categories: ["Local Micro Brew",]).opacity(0.5)
            }
            .padding(.top, .xLarge)
            
            Image("favourite")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 160)
                .opacity(0)
                .anchorPreference(key: RectKey.self, value: .bounds, transform: { anchor in
                    return ["HEADERBOUNDS": anchor]
                })
                .padding(.bottom, .large)
        }
        .padding([.horizontal, .top], .large)
        .padding(.top, safeArea.top)
        .background (
            Rectangle()
                .fill(.linearGradient(colors: [.purple, .purple, .pink], startPoint: .top, endPoint: .bottom))
        )
        .rotation3DEffect(.init(degrees: animator.startAnimation ? 90.0 : 0.0), axis: (x: 1, y: 0, z: 0), anchor: UnitPoint(x: 0.5, y: 0.8))
        .offset(y: animator.startAnimation ? -100 : 0)
    }
    
    @ViewBuilder func FavouritesCardView () -> some View {
        VStack {
            Text("Favourites")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .padding(.vertical)
            
            GeometryReader { _ in
                VStack(spacing: 0) {
                    ForEach(sampleCards.indices, id: \.self) { index in
                        Favourite(index: index)
                    }
                }
                .padding(.horizontal, .xxLarge)
                .offset(y: offsetY)
                .offset(y: currentCardIndex * -200.0)
                
                //Gradient
                Rectangle()
                    .fill(.linearGradient(colors: [
                        .clear,
                        .clear,
                        .clear,
                        .clear,
                        .black.opacity(0.3),
                        .black.opacity(0.6),
                        .black.opacity(0.8),
                    ], startPoint: .top, endPoint: .bottom))
                    .allowsHitTesting(false) //users need to interact with underlying views
                
                #warning("when user clicks on one past favourite restaurant, they can rebook without going through the payment walkthrough")
                Button {
                    makeBookingPurchase()
                } label: {
                    Text("Confirm Booking") //ADD PRICE FROM FAVOURITE RESTAURANT CARD
                        .font(.callout)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.horizontal, .xxLarge)
                        .padding(.vertical, .medium)
                        .background(
                            Capsule()
                                .fill(LinearGradient(mycolors: .purple, .pink, .purple))
                        )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                .padding(.bottom, safeArea.bottom == 0 ? .large : safeArea.bottom)
            }
            .coordinateSpace(name: "SCROLL")
        }
        .contentShape(Rectangle())
        //MARK: swipe up functionality
        .gesture (
            DragGesture()
                .onChanged { value in
                    offsetY = value.translation.height * 0.3 //MARK: multiplying by 0.3 to decrease animation speed
                }
                .onEnded { value in
                    let translation = value.translation.height
                    withAnimation(.easeInOut) {
                        //increasing/decreasing index based on condition
                        //MARK: We used value of 100, which is half of the stated frame of 200 on Favourite (i.e. card height)
                        if translation > 0 && translation < 100 && currentCardIndex > 0{
                            currentCardIndex -= 1
                        }
                        if translation < 0 && -translation > 100 && currentCardIndex < CGFloat(sampleCards.count - 1) {
                            currentCardIndex += 1
                        }
                        offsetY = .zero
                    }
                }
        )
        .background(Color.white.ignoresSafeArea())
        .clipped()
        .rotation3DEffect(.init(degrees: animator.startAnimation ? -90.0 : 0.0), axis: (x: 1, y: 0, z: 0), anchor: UnitPoint(x: 0.5, y: 0.25))
        .offset(y: animator.startAnimation ? 100 : 0)
    }
    
    @ViewBuilder func Favourite(index: Int) -> some View {
        GeometryReader {
            let geometry = $0.size
            let minY = $0.frame(in: .named("SCROLL")).minY
            let progress = minY / geometry.height
            let constrainedProgress = progress > 1 ? 1 : progress < 0 ? 0 : progress
            
            Image(sampleCards[index].cardImage)
                .resizedToFill(width: geometry.width, height: geometry.height)
                .cornerRadius(30)
                .shadow(color: .black.opacity(0.5), radius: 8, x: 6, y: 6)
            //MARK: Stacked Card Animation
                .rotation3DEffect(.init(degrees: constrainedProgress * 40.0), axis: (x: 1, y: 0, z: 0), anchor: .bottom)
                .padding(.top, progress * -160.0)
            //moving current card out of view when dragged
                .offset(y: progress < 0 ? progress * 250 : 0)
        }
        .frame(height: 200)
        .zIndex(Double(sampleCards.count - index))
        .onTapGesture {
            
        }
    }
}

struct FavouritesHome_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesContentView()
            //.preferredColorScheme(.dark)
    }
}

struct CloudView: View {
    var delay: Double
    var size: CGSize
    @State private var move : Bool = false
    
    var body: some View {
        ZStack {
            Image("cloud")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size.width * 3)
                .offset(x: move ? -size.width * 2 : size.width * 2)
        }
        .onAppear {
            //Delay is the speed of animation movement
            withAnimation(.easeIn(duration: 1).delay(delay)) {
                move.toggle()
            }
        }
    }
}

#warning("code string value here should come from Firebase")
struct BookedVenueView : View {
    var alignment: HorizontalAlignment = .leading
    var place: String
    var code: String
    var time: String
    var categories : [String] = []
    
    var body: some View {
        VStack {
            Text(place)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            Divider()
            
            HStack {
                ForEach(categories, id: \.self){ text in
                    Text("|  " + text + ".")
                        .font(.caption)
                        .foregroundColor(.white)
                        .truncationMode(.tail)
                        .multilineTextAlignment(.center)
                }
            }
            
            Text(code)
                .font(.title)
                .foregroundColor(.white)
            
            Text(time)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
    }
}

struct PaymentDetailView: View {
    var size: CGSize
    var safeArea: EdgeInsets
    @EnvironmentObject var animator : Animator
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                VStack {
                    Image("chef")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                    
                    Text("Your order has been submitted successfully")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.top, .medium)
                    
                    Text("Check your inbox for order confirmation")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                .frame(maxWidth: .infinity)
                .padding(.top, .xxLarge)
                .padding(.bottom, .xxxLarge)
                .background(
                    RoundedRectangle(cornerRadius: .large, style: .continuous)
                        .fill(.white.opacity(0.1))
                )
                
                HStack {
                    #warning("create scroll like effect here")
                    BookedVenueView(place: "The Icarus", code: "JHB", time: "17:30", categories: ["Greek", "Vegan"])

                    VStack {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                        
                        Text("Next Order")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    
                    BookedVenueView(alignment: .trailing, place: "Dionysius Cafe", code: "CPT", time: "14:30", categories: ["Local Micro Brew",]).opacity(0.5)
                }
                .padding(.large)
                .padding(.bottom, 70)
                .background(
                    RoundedRectangle(cornerRadius: .large, style: .continuous)
                        .fill(.ultraThinMaterial)
                )
                .padding(.top, -.xLarge)
            }
            .padding(.horizontal, .large)
            .padding(.top, safeArea.top + .large)
            .padding([.horizontal, .bottom], .large)
            .offset(y: animator.showFinalView ? 0 : 300)
            .background(
                Rectangle()
                    .fill(.pink)
                    .scaleEffect(y: animator.showFinalView ? 1 : 0.001, anchor: .top)
                    .padding(.bottom, 80)
            )
            .clipped()
            
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    AccountInformationView()
                }
                .offset(y: animator.showFinalView ? 0 : size.height)
            }
        }
        .animation(.easeInOut(duration: animator.showFinalView ? 0.4 : 0.1).delay(animator.showFinalView ? 0.4 : 0), value: animator.showFinalView)
    }
    
    @ViewBuilder func ContactView (name: String, email: String, profileImage: String) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: .small) {
                Text(name)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(email)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Image(profileImage)
                .resizedToFill(width: .xxxLarge, height: .xxxLarge)
                .clipShape(Circle())
        }
        .padding(.horizontal, .large)
    }
    
    @ViewBuilder func AccountInformationView () -> some View {
        VStack(spacing: .large) {
            HStack {
                #warning("Include ambience and time information here")
                OrderInformationView(title: "Venue", subtitle: "The Icarus")
                OrderInformationView(title: "Cuisine", subtitle: "Greek")
                OrderInformationView(title: "Meal", subtitle: "Taramasalata")
                OrderInformationView(title: "Specifics", subtitle: "No Category")
            }
            
            ContactView(name: "Jonathan Burke", email: "jonathan@gmail.com", profileImage: "chef")
                .padding(.top, .xxLarge)
            
            VStack(alignment: .leading, spacing: .small) {
                Text("Total")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                Text("R536.79")
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, .xLarge)
            .padding(.leading, .large)

            Button {
                resetAnimationAndView()
            } label: {
                Text("Home")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, .xxLarge)
                    .padding(.vertical, .medium)
                    .background(
                        Capsule()
                            .fill(.linearGradient(colors: [.purple, .purple, .pink], startPoint: .top, endPoint: .bottom))
                    )
            }
            .padding(.top, .large)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .padding(.bottom, safeArea.bottom)
        }
        .padding(.large)
        .padding(.top, .xLarge)
    }
    
    @ViewBuilder func OrderInformationView (title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: .small) {
            Text(title)
                .font(.caption2)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            Text(subtitle)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
    
    ///resetting animation
    func resetAnimationAndView() {
        animator.currentPaymentStatus = .started
        animator.showClouds = false
        withAnimation(.easeInOut(duration: 0.3)) {
            animator.showFinalView = false
        }
        
        animator.showLoadingView = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            animator.startAnimation = false
        }
    }
}

/// Animator observable object to hold all the animation properties
class Animator : ObservableObject {
    @Published var startAnimation : Bool = false
    @Published var initialImagePostion : CGRect = .zero
    @Published var currentPaymentStatus: PaymentStatus = .initiated
    @Published var showLoadingView : Bool = false
    @Published var showClouds : Bool = false
    @Published var showFinalView: Bool = false
}

//MARK: Anchor Preference Key
/*
 Functionality to be implemented - Make Header Image transparent & rotate it out of screen, and overlay same image in place of the original
 
 we use PrefenceKey here because the Header Image rotates when 3D animation is applied & we must first determine its screen position in order to add that image as an overlay. With preferenceKey we can recover its precise location on screen
 */

struct RectKey: PreferenceKey {
    static var defaultValue: [String: Anchor<CGRect>] = [:]
    static func reduce(value: inout [String : Anchor<CGRect>], nextValue: () -> [String : Anchor<CGRect>]) {
        value.merge(nextValue()){$1}
    }
}

