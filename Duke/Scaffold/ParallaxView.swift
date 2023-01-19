//
//  ParallaxView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/14/23.
//

import SwiftUI

struct ParallaxView: View {
    //Gesture properties
    @State private var offset: CGSize = .zero
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            let imageSize = size.width * 0.7
            
            VStack {
                Image("chef")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: imageSize)
                    .rotationEffect(.init(degrees: -30))
                    .zIndex(1)
                    .offset(x: -20)
                    .offset(x: offsetToAngle().degrees * 5, y: offsetToAngle(true).degrees * 5)
                
                Text("DUKE")
                    .font(.system(size: 60))
                    .fontWeight(.bold)
                    .padding(.top, -70)
                    .padding(.bottom, 55)
                    .zIndex(0)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Duke")
                        .font(.callout)
                        .fontWeight(.semibold)
                        .kerning(2)
                    
                    HStack {
                        BlendedText("Discover your ambience")
                        
                        Spacer()
                        
                        BlendedText("New on iOS")
                    }

                    HStack{
                        BlendedText("Create your favourites")
                        
                        Spacer()
                        
                        Button {
                            
                        } label: {
                            Text("Join")
                                .fontWeight(.bold)
                                .foregroundColor(Color("rw-dark"))
                                .padding(.vertical, 12)
                                .padding(.horizontal, .large)
                                .background(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .fill(Color.yellow)
                                        .brightness(-0.1)
                                )

                        }
                    }
                    .padding(.top, .large)
                    
                    Image("star")
                        .resizedToFit(width: 35, height: 35)
                        .frame(maxWidth: .infinity)
                        .padding(.bottom, 10)
                    //MARK: iOS 16 code
                    /*if #available(iOS 16.0, *) {
                        Text("Duke")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .fontWidth(.compressed)
                        
                        HStack {
                            BlendedText("Discover your ambience")
                            
                            Spacer()
                            
                            BlendedText("New on iOS")
                        }
                        
                        HStack{
                            BlendedText("Create your favourites")
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Text("Join")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("rw-dark"))
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, .large)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color.yellow)
                                            .brightness(-0.1)
                                    )
                            }
                        }
                        .padding(.top, .large)
                        
                        Image("star")
                            .resizedToFit(width: 35, height: 35)
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 10)
                    } else {
                        // Fallback on earlier versions
                        Text("Duke")
                            .font(.callout)
                            .fontWeight(.semibold)
                            .kerning(2)
                        
                        HStack {
                            BlendedText("Discover your ambience")
                            
                            Spacer()
                            
                            BlendedText("New on iOS")
                        }

                        HStack{
                            BlendedText("Create your favourites")
                            
                            Spacer()
                            
                            Button {
                                
                            } label: {
                                Text("Join")
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("rw-dark"))
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, .large)
                                    .background(
                                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                                            .fill(Color.yellow)
                                            .brightness(-0.1)
                                    )

                            }
                        }
                        .padding(.top, .large)
                        
                        Image("star")
                            .resizedToFit(width: 35, height: 35)
                            .frame(maxWidth: .infinity)
                            .padding(.bottom, 10)
                    }*/
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .foregroundColor(.white)
            .padding(.horizontal, .large)
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
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onChanged({ value in
                        offset = value.translation
                    })
                    .onEnded({ _ in
                        withAnimation(.interactiveSpring(response: 0.6, dampingFraction: 0.32, blendDuration: 0.32)) {
                            offset = .zero
                        }
                    })
            )
        }
    }
    
    //MARK: method that translates offset (CGSize) into Angle values
    func offsetToAngle(_ isVertical: Bool = false) -> Angle {
        let progress = (isVertical ? offset.height : offset.width) / (isVertical ? getScreenSize().height : getScreenSize().width)
        return .init(degrees: progress * 10)
    }
    
    @ViewBuilder func BlendedText(_ stringValue: String) -> some View {
        //MARK: iOS 16 code
        /*if #available(iOS 16.0, *) {
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
        }*/
        Text(stringValue)
            .font(.title3)
            .fontWeight(.semibold)
            .kerning(2)
            .blendMode(.difference)
    }
}

struct ParallaxView_Previews: PreviewProvider {
    static var previews: some View {
        ParallaxView()
            .preferredColorScheme(.dark)
    }
}
