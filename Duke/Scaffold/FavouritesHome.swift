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
            FavouritesCardView()
        }
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
            }
            .coordinateSpace(name: "SCROLL")
        }
        .contentShape(Rectangle())
        .offset(y: offsetY)
        .gesture (
            DragGesture()
                .onChanged { value in
                    offsetY = value.translation.height
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
            
        }
        .frame(height: 200)
        .zIndex(Double(sampleCards.count - index))
    }
    
    #warning("code string value here should come from Firebase")
    @ViewBuilder func BookedVenueView(alignment: HorizontalAlignment = .leading, place: String, code: String, timing: String) -> some View {
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

struct FavouritesHome_Previews: PreviewProvider {
    static var previews: some View {
        FavouritesContentView()
            .preferredColorScheme(.dark)
    }
}
