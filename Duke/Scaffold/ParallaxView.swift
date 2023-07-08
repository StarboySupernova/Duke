//
//  ParallaxView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/14/23.
//

import SwiftUI

struct ParallaxView: View {
    //Gesture properties
    @State private var parallaxOffset: CGSize = .zero
    @GestureState var isDragging: Bool = false
    @State var offset: CGFloat = .zero
    @State var height: CGFloat = 0 //should pass this to View corresponding to Ticket as a Binding
    @EnvironmentObject var preferenceStore: UserPreference
    @Binding var parallaxProperties: [ParallaxProperties]
    var headerText: String
    var buttonText: [String]
    var imageName: String
    //attach to each headertext & image-name to display each one
    //require button array to be passed in as is, and create each button in-view
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let imageSize = size.width * 0.75
            
            VStack(alignment: .leading) {
                //label & icon here, and additional icon array parameter
                Text(headerText)
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .padding(.top, -60)
                    .padding(.bottom, 55)
                    .padding(.horizontal, .small)
                    .zIndex(0)
                
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(25)
                    .frame(width: imageSize)
                    .rotationEffect(.init(degrees: 0))
                    .zIndex(1)
                    .offset(x: -20)
                    .offset(x: offsetToAngle().degrees * 5, y: offsetToAngle(true).degrees * 5)
                
                VStack(alignment: .leading, spacing: 10) {
                    
                    //for each buttontext array element create new button
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: getRect().width * 0.05) {
                            ForEach(buttonText, id: \.self) { text in
                                SelectionButton(buttonText: text, isSelected: preferenceStore.assignBoolBinding(for: text)) //add presentedText parameter here to allow us to customize what appears on the button
                            }
                        }
                    }
                    
                    HStack {
                        BlendedText("Create your favourites")
                            .padding(.horizontal, .medium)
                        
                        Spacer()
                        
                        Button {
                            removeProperty()
                        } label: {
                            Text("Next") //animation to move to next card should show parallax features
                                .fontWeight(.bold)
                                .foregroundColor(Color("rw-dark"))
                                .padding(.vertical, 12)
                                .padding(.horizontal, 16)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color.yellow)
                                        .brightness(-0.1)
                                )
                            
                        }
                        .offset(x: offsetToAngle().degrees * 5, y: offsetToAngle(true).degrees * 5)
                    }
                    .padding(.top, .small)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
            }
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.top, 65)
            .frame(width: imageSize)
            .background (
                ZStack(alignment: .topTrailing) {
                    Rectangle()
                        .fill(Color("rw-dark"))
                    
                    Circle()
                        .fill(.yellow)
                        .scaleEffect(1.2, anchor: .leading)
                        .offset(x: imageSize * 0.3, y: -imageSize * 0.1)
                        .frame(width: imageSize, height: imageSize)
                }
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            )
            .rotation3DEffect(offsetToAngle(true), axis: (x: -1, y: 0, z: 0))
            .rotation3DEffect(offsetToAngle(), axis: (x: 0, y: 1, z: 0))
            .rotation3DEffect(offsetToAngle(true) * 0.1, axis: (x: 0, y: 0, z: 1))
            .scaleEffect(0.9)
            .frame(maxWidth: .infinity, maxHeight: getRect().height)
            //.contentShape(Rectangle())
            .clipped()
            .shadow(color: Color.red, radius: 10, x: 0, y: 0) //set this to work only for first card
            
            
            
//            let zIndexModifier = shadowModifier
//                .zIndex(getIndex() == 0 && offset > 100 ? Double(CGFloat(parallaxProperties.count) - getIndex()) - 1 : Double(CGFloat(parallaxProperties.count) - getIndex()))
            
//            VStack {
//
//            }

//            /// to determine which card shows up on top of the others based on getindex
//            /// when card is the first in the array, and it has been offset enough from center, the underlying cards come to the foreground, and wll have a higher zindex than the card currently being swiped out
//            .zIndex(getIndex() == 0 && offset > 100 ? Double(CGFloat(parallaxProperties.count) - getIndex()) - 1 : Double(CGFloat(parallaxProperties.count) - getIndex()))//MARK: #warning("very iffy zindex logic for determining which card appears on top of the other")
            .rotationEffect(.init(degrees: getRotation(angle: 10))) //- problematic line commented out.animation is not smooth when swiping out without this line
            .rotationEffect(getIndex() == 1 ? .degrees(-6) : .degrees(0))
            .rotationEffect(getIndex() == 2 ? .degrees(6) : .degrees(0))
            .scaleEffect(getIndex() == 0 ? 1 : 0.9)
            ///// to make cards shift right or left of centerpiece card
            .offset(x: getIndex() == 1 ? -40 : 0)
            .offset(x: getIndex() == 2 ? 40 : 0)
            .offset(x: offset)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .gesture (
                DragGesture()
                    .updating($isDragging, body: { _, out, _ in
                        out = true
                    })
                    .onChanged({ value in
                        var translation = value.translation.width
                        let index = parallaxProperties.first(where: {$0.headerText == headerText})
                        translation = parallaxProperties.first?.headerText == headerText ? translation : 0
                        translation = isDragging ? translation : 0

                        parallaxOffset = value.translation

                        withAnimation(.easeInOut(duration: 0.3)) {
                            offset = translation
                            height = -offset / 5
                        }
                    })
                    .onEnded({ _ in
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.32, blendDuration: 0.32)) {
                            parallaxOffset = .zero
                        }

                        let index = parallaxProperties.first(where: {$0.headerText == self.headerText})
                        let width = UIScreen.main.bounds.width
                        let swipedLeft = -offset > (width / 2)
                        withAnimation(.easeInOut(duration: 0.5)) {
                            if swipedLeft {
                                offset = -width
                                removeProperty()
                            } else { //add else if swipedRight
                                offset = .zero
                                height = .zero
                            }
                        }
                    })
            )
            
        }
    }
    
    //MARK: method that translates offset (CGSize) into Angle values
    func offsetToAngle(_ isVertical: Bool = false) -> Angle {
        let progress = (isVertical ? parallaxOffset.height : parallaxOffset.width) / (isVertical ? getScreenSize().height : getScreenSize().width)
        return .init(degrees: progress * 10)
    }
    
    func getIndex() -> Int {
        guard let index = parallaxProperties.firstIndex(where: { $0.headerText == self.headerText }) else {
            return 0
        }
        return index
    }

    
    func getRotation(angle: Double) -> Double {
        let width = UIScreen.main.bounds.width - 50
        let progress = offset / width
        
        return Double(progress * angle)
    }
    
    func removeProperty() {
        let index = getIndex()
        withAnimation(.spring()) {
            parallaxProperties.removeFirst()
        }
    }
    
    @ViewBuilder
    func GridStackView(_ preferenceStore: UserPreference, _ imageSize: Double) -> some View {
        VStack(alignment: .leading) {
            //label & icon here, and additional icon array parameter
            Text(headerText)
                .font(.system(size: 30))
                .fontWeight(.bold)
                .padding(.top, -60)
                .padding(.bottom, 55)
                .padding(.horizontal, .small)
                .zIndex(0)
            
            Image(imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(25)
                .frame(width: imageSize)
                .rotationEffect(.init(degrees: 0))
                .zIndex(1)
                .offset(x: -20)
                .offset(x: offsetToAngle().degrees * 5, y: offsetToAngle(true).degrees * 5)
            
            VStack(alignment: .leading, spacing: 10) {
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: getRect().width * 0.05) {
                        ForEach(buttonText, id: \.self) { text in
                            SelectionButton(buttonText: text, isSelected: preferenceStore.assignBoolBinding(for: text))
                        }
                    }
                }
                
                HStack {
                    BlendedText("Create your favourites")
                        .padding(.horizontal, .medium)
                    
                    Spacer()
                    
                    Button {
                        removeProperty()
                    } label: {
                        Text("Next")
                            .fontWeight(.bold)
                            .foregroundColor(Color("rw-dark"))
                            .padding(.vertical, 12)
                            .padding(.horizontal, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .fill(Color.yellow)
                                    .brightness(-0.1)
                            )
                        
                    }
                    .offset(x: offsetToAngle().degrees * 5, y: offsetToAngle(true).degrees * 5)
                }
                .padding(.top, .small)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.horizontal, 16)
        .padding(.top, 65)
        .frame(width: imageSize)
        .background (
            ZStack(alignment: .topTrailing) {
                Rectangle()
                    .fill(Color("rw-dark"))
                
                Circle()
                    .fill(.yellow)
                    .scaleEffect(1.2, anchor: .leading)
                    .offset(x: imageSize * 0.3, y: -imageSize * 0.1)
                    .frame(width: imageSize, height: imageSize)
            }
                .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
        )
        .rotation3DEffect(offsetToAngle(true), axis: (x: -1, y: 0, z: 0))
        .rotation3DEffect(offsetToAngle(), axis: (x: 0, y: 1, z: 0))
        .rotation3DEffect(offsetToAngle(true) * 0.1, axis: (x: 0, y: 0, z: 1))
        .scaleEffect(0.9)
        .frame(maxWidth: .infinity, maxHeight: getRect().height)
        .contentShape(Rectangle())
    }

    
    @ViewBuilder func BlendedText(_ stringValue: String) -> some View {
        //MARK: iOS 16 code
        if #available(iOS 16.0, *) {
            Text(stringValue)
                .font(.title3)
                .fontWeight(.semibold)
                .fontWidth(.compressed)
                .blendMode(.difference)
        } else {
            // Fallback on earlier versions
            Text(stringValue)
                .font(.title3)
                .fontWeight(.semibold)
                .kerning(2)
                .blendMode(.difference)
        }
    }
}

struct ParallaxView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView()
            .environmentObject(UserPreference())
            .preferredColorScheme(.dark)
    }
}
