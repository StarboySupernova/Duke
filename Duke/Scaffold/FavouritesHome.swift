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
    @State var offsetY: CGFloat = 0
    @State var currentCardIndex: CGFloat = 0
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
                })
                .zIndex(1)
            FavouritesCardView()
                .zIndex(0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            
        )
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
                BookedVenueView(place: "Johannesburg", code: "JHB", timing: "02:30")
                
                VStack {
                    Image(systemName: "chevron.left")
                        .font(.title3)
                    
                    Text("Next Order")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                
                BookedVenueView(alignment: .trailing, place: "Cape Town", code: "CPT", timing: "14:30").opacity(0.5)
            }
            .padding(.top, .xLarge)
            
            Image("favourite")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height: 160)
                .padding(.bottom, .large)
        }
        .padding([.horizontal, .top], .large)
        .padding(.top, safeArea.top)
        .background (
            Rectangle()
                .fill(.linearGradient(colors: [.purple, .purple, .pink], startPoint: .top, endPoint: .bottom))
        )
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
                        .white.opacity(0.3),
                        .white.opacity(0.8),
                        .white,
                    ], startPoint: .top, endPoint: .bottom))
                    .allowsHitTesting(false) //users need to interact with underlying views
                
                #warning("when user clicks on one past favourite restaurant, they can rebook without going through the payment walkthrough")
                Button {
                    
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
    }
    
    @ViewBuilder func Favourite(index: Int) -> some View {
        GeometryReader {
            let geometry = $0.size
            let minY = $0.frame(in: .named("SCROLL")).minY
            let progress = minY / geometry.height
            let constrainedProgress = progress > 1 ? 1 : progress < 0 ? 0 : progress
            
            Image(sampleCards[index].cardImage)
                .resizedToFit(width: geometry.width, height: geometry.height)
                .shadow(color: .primary.opacity(0.14), radius: 8, x: 6, y: 6)
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
            .preferredColorScheme(.dark)
    }
}

#warning("code string value here should come from Firebase")
struct BookedVenueView : View {
    var alignment: HorizontalAlignment = .leading
    var place: String
    var code: String
    var timing: String
    
    var body: some View {
        VStack {
            Text(place)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
            
            Text(code)
                .font(.title)
                .foregroundColor(.white)
            
            Text(timing)
                .font(.caption)
                .foregroundColor(.white.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
    }
}

struct PaymentDetailView: View {
    var size: CGSize
    var safeArea: EdgeInsets
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                VStack {
                    Image("chef")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                    
                    Text("Your order has been submitted")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .padding(.top, .medium)
                    
                    Text("We are waiting for booking confirmation")
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
                    BookedVenueView(place: "Johannesburg", code: "JHB", timing: "02:30")
                    
                    VStack {
                        Image(systemName: "chevron.left")
                            .font(.title3)
                        
                        Text("Next Order")
                            .fontWeight(.semibold)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    
                    BookedVenueView(alignment: .trailing, place: "Cape Town", code: "CPT", timing: "14:30").opacity(0.5)
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
            .background(
                Rectangle()
                    .fill(.pink)
                    .padding(.bottom, 80)
            )
            
            GeometryReader { geometry in
                ScrollView(.vertical, showsIndicators: false) {
                    AccountInformationView()
                }
            }

        }
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
                OrderInformationView(title: "Dinner/Supper", subtitle: "African Traditional")
                OrderInformationView(title: "Breakfast", subtitle: "Greek")
                OrderInformationView(title: "Lunch", subtitle: "Chinese")
                OrderInformationView(title: "Breakfast", subtitle: "No Category")
            }
            
            ContactView(name: "Jonathan", email: "jonathan@gmail.com", profileImage: "chef")
                .padding(.top, .xxLarge)
            ContactView(name: "Jonathan", email: "jonathan@gmail.com", profileImage: "chef")
            
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
}

