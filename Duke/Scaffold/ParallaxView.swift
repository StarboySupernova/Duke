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
                        .fill(Color.clear)

                    Image("background1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: getRect().height * 0.75)
                        .overlay(
                            ZStack {
                                Image("logo1")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 180)
                                    .offset(x: parallaxOffset.width/8, y: parallaxOffset.height/15)
                                Image("logo2")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 400)
                                    .offset(x: parallaxOffset.width/10, y: parallaxOffset.height/20)
                                Image("logo3")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 392, height: getRect().height * 0.75)
                                    .cornerRadius(50)
                                    .blendMode(.overlay)
                                    .offset(x: parallaxOffset.width/15, y: parallaxOffset.height/30)
                            }
                        )
                        .overlay(gloss1.blendMode(.softLight))
                        .overlay(
                            Image("gloss2")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .blendMode(.luminosity)
                                .mask(
                                    LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: parallaxOffset.height/100, y: parallaxOffset.height/100))
                                        .frame(width: 392)
                                )
                        )
                        .overlay(gloss2.blendMode(.overlay))
                        .overlay(
                            LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5086403146)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: abs(parallaxOffset.height)/10 - 10, y: abs(parallaxOffset.height)/10 - 10))
                                .cornerRadius(50)
                        )
                        .overlay(
                            LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.5086403146)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: parallaxOffset.height/10, y: parallaxOffset.height/10))
                                .cornerRadius(50)
                        )
                        .overlay(
                            // Outline
                            RoundedRectangle(cornerRadius: 50)
                                .strokeBorder(.linearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.740428394)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.7562086093)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: parallaxOffset.width/100 + 0.5, y: parallaxOffset.height/100 + 0.5)))
                        )
                        .overlay {
                            LinearGradient(colors: [Color(#colorLiteral(red: 0.3647058904, green: 0.06666667014, blue: 0.9686274529, alpha: 0.5152369619)), Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 0.4812706954))], startPoint: .topLeading, endPoint: .bottomTrailing)
                                .blendMode(.overlay)
                                .cornerRadius(50)
                        }
                        .cornerRadius(50)
                        .background(
                            RoundedRectangle(cornerRadius: 50)
                                .fill(.black)
                                .opacity(0.5)
                                .blur(radius: 50)
                                .offset(y: 50)
                                .blendMode(.overlay)
                        )
                        .scaleEffect(0.9)
                        .offset(x: offsetToAngle().degrees * 5, y: offsetToAngle(true).degrees * 5)

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
            .frame(maxWidth: .infinity, maxHeight: getRect().height * 0.75)
            //.contentShape(Rectangle())
            .clipped()
            .shadow(color: Color.red, radius: 10, x: 0, y: 0) //set this to work only for first card
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
            .gesture(
                DragGesture()
                    .updating($isDragging, body: { _, out, _ in
                        out = true
                    })
                    .onChanged({ value in
                        var translation = value.translation.width
                        translation = parallaxProperties.first?.headerText == headerText ? translation : 0
                        translation = isDragging ? translation : 0

                        parallaxOffset = value.translation

                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                offset = translation
                                height = -offset / 5
                            }
                        }
                    })
                    .onEnded({ _ in
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.32, blendDuration: 0.32)) {
                            parallaxOffset = .zero
                        }

                        let width = UIScreen.main.bounds.width
                        let swipedLeft = -offset > (width / 3.5)
                        withAnimation(.easeInOut(duration: 0.5)) {
                            if swipedLeft {
                                offset = -width
                                removeProperty()
                            } else { // add else if swipedRight
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
    
    var gloss1: some View {
        Image("gloss1")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .mask(
                LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: abs(-parallaxOffset.height)/100+1, y: abs(-parallaxOffset.height)/100+1))
                    .frame(width: 392)
            )
    }
    
    var gloss2: some View {
        Image("gloss2")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .mask(
                LinearGradient(colors: [Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)), Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 0))], startPoint: UnitPoint(x: 0, y: 0), endPoint: UnitPoint(x: abs(parallaxOffset.height)/100+1, y: abs(parallaxOffset.height)/100+1))
                    .frame(width: 392)
            )
    }
}

struct ParallaxView_Previews: PreviewProvider {
    static var previews: some View {
        SelectionView()
            .environmentObject(UserPreference())
            .preferredColorScheme(.dark)
    }
}
