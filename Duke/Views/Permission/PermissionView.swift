//
//  ContentView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/2/22.
//

import SwiftUI
import CoreLocationUI
import MapKit


struct PermissionView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var homeViewModel: HomeViewModel
    @State private var isAnimating: Bool = false
    @State private var showMap: Bool = false
    let action : () -> Void
    
    
    
    var body: some View {
        GeometryReader { geometry  in
            VStack(alignment: .center) {
                
                Spacer()
                
                VStack {
                    ZStack(alignment: .topLeading) {
                        ZStack {}
                            .frame(width: getRelativeWidth(240.0),
                                   height: getRelativeHeight(307.0),
                                   alignment: .leading)
                            .background(RoundedCorners(topRight: 60.0,
                                                       bottomRight: 40.0)
                                .fill(LinearGradient(gradient: Gradient(colors: [Color(red: 0.45, green: 0.72, blue: 0.98).opacity(0.8),Color("backgroundColor-1").opacity(0.8)]),
                                                     startPoint: .topLeading,
                                                     endPoint: .bottomTrailing)))
                            .shadow(color: Color.black, radius: 40,
                                    x: 0, y: 20)
                            .rotationEffect(.degrees(20))
                        
                        ZStack(alignment: .topTrailing) {
                            VStack {
                                VStack(alignment: .leading, spacing: 0) {
                                    Text("Welcome To")
                                        .font(FontScheme
                                            .kRobotoCondensedMedium(size: getRelativeHeight(13.0)))
                                        .fontWeight(.medium)
                                        .foregroundColor(Color.white)
                                        .minimumScaleFactor(0.5)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: getRelativeWidth(69.0),
                                               height: getRelativeHeight(16.0),
                                               alignment: .topLeading)
                                        .padding(.trailing)
                                    
                                    Text("DUKE")
                                        .font(.largeTitle)
                                        .fontWeight(.ultraLight)
                                        .padding(.bottom, .large)
                                        .foregroundColor(Color.white)
                                        .shadow(color: Color.black,
                                                radius: 40, x: 0, y: 20)
                                        .padding(.top, getRelativeHeight(10.0))
                                        .padding(.trailing, getRelativeWidth(10.0))
                                    Text("Savour the flavour, discover with Duke, the food sanctuary")
                                        .fontWeight(.regular)
                                        .foregroundColor(Color.white)
                                        .multilineTextAlignment(.leading)
                                        
                                    HStack {
                                        Button(action: {}, label: {
                                            Image("insight")
                                        })
                                        .frame(width: getRelativeWidth(31.0),
                                               height: getRelativeHeight(32.0),
                                               alignment: .center)
                                        .background(RoundedCorners(topLeft: 16.0,
                                                                   topRight: 16.0,
                                                                   bottomLeft: 16.0,
                                                                   bottomRight: 16.0)
                                            .fill(Color.black))
                                        Text("Join Our Food Lover's Club")
                                            .font(FontScheme
                                                .kRobotoCondensedRegular(size: getRelativeHeight(13.0)))
                                            .fontWeight(.regular)
                                            .foregroundColor(Color.white)
                                            .multilineTextAlignment(.leading)
                                    }
                                    .frame(width: getRelativeWidth(141.0),
                                           height: getRelativeHeight(32.0),
                                           alignment: .leading)
                                    .padding(.top, getRelativeHeight(8.0))
                                    .padding(.trailing, getRelativeWidth(10.0))
                                    
                                    HStack {
                                        Button(action: {}, label: {
                                            Image("search")
                                        })
                                        .frame(width: getRelativeWidth(31.0),
                                               height: getRelativeHeight(32.0),
                                               alignment: .center)
                                        .background(RoundedCorners(topLeft: 16.0,
                                                                   topRight: 16.0,
                                                                   bottomLeft: 16.0,
                                                                   bottomRight: 16.0)
                                            .fill(Color.black))
                                                                        
                                        Text("Explore your senses")
                                            .fontWeight(.regular)
                                            .foregroundColor(Color.white)
                                            .multilineTextAlignment(.leading)
                                            .minimumScaleFactor(0.5)
                                            .frame(width: getRelativeWidth(107.0),
                                                   height: getRelativeHeight(16.0),
                                                   alignment: .topLeading)
                                            .padding(.top, getRelativeHeight(8.0))
                                            .padding(.bottom, getRelativeHeight(7.0))
                                        
                                    }
                                    .frame(width: getRelativeWidth(199.0),
                                           height: getRelativeHeight(32.0),
                                           alignment: .leading)
                                    .padding(.top, getRelativeHeight(10.0))
                                }
                                .frame(width: getRelativeWidth(199.0),
                                       height: getRelativeHeight(229.0),
                                       alignment: .center)
                                .padding(.vertical, getRelativeHeight(20.53))
                                .padding(.horizontal, getRelativeWidth(20.0))
                                
                                Text("")
                                    .padding(.horizontal, getRelativeWidth(6.0))
                                    .frame(width: getRelativeWidth(40.0),
                                           height: getRelativeHeight(20.0),
                                           alignment: .center)
                                    .background(
                                        Color("majenta")
                                        .cornerRadius(10, corners: [.allCorners])
                                    )
                                    .padding(.vertical, getRelativeHeight(6.0))
                            }
                           
                            
                            Button(action: {}, label: {
                                Image("pencil")
                            })
                            .frame(width: getRelativeWidth(32.0),
                                   height: getRelativeWidth(32.0),
                                   alignment: .center)
                            .background(RoundedCorners(topLeft: 16.0,
                                                       topRight: 16.0,
                                                       bottomLeft: 16.0,
                                                       bottomRight: 16.0)
                                .fill(Color.black))
                            
                        }
                        .overlay(RoundedCorners(topRight: 30.0, bottomLeft: 40.0,
                                                bottomRight: 40.0)
                            .stroke(Color.white.opacity(0.2),
                                    lineWidth: 1))
                        .background(RoundedCorners(topRight: 30.0, bottomLeft: 40.0,
                                                   bottomRight: 40.0)
                            .fill(Color.pink.opacity(0.4)))
                        .shadow(radius: 40)
                        .padding(.bottom, getRelativeHeight(28.0))
                    }
                   
                    
    //                        VStack(alignment: .leading, spacing: 0) {
    //                            Text(StringConstants.kLbl30Tutorials)
    //                                .font(FontScheme
    //                                    .kRobotoCondensedMedium(size: getRelativeHeight(13.0)))
    //                                .fontWeight(.medium)
    //                                .foregroundColor(ColorConstants.WhiteA700B2)
    //                                .minimumScaleFactor(0.5)
    //                                .multilineTextAlignment(.leading)
    //                                .frame(width: getRelativeWidth(96.0),
    //                                       height: getRelativeHeight(16.0),
    //                                       alignment: .topLeading)
    //                                .padding(.top, getRelativeHeight(20.0))
    //                                .padding(.horizontal, getRelativeWidth(20.0))
    //                            VStack(spacing: 0) {
    //                                ScrollView(.vertical, showsIndicators: false) {
    //                                    LazyVStack {
    //                                        ForEach(0 ... 2, id: \.self) { index in
    //                                            Row3Cell()
    //                                        }
    //                                    }
    //                                }
    //                            }
    //                            .frame(width: getRelativeWidth(297.0), alignment: .center)
    //                            .padding(.vertical, getRelativeHeight(8.0))
    //                            .padding(.horizontal, getRelativeWidth(20.0))
    //                        }
    //                        .frame(width: getRelativeWidth(337.0),
    //                               height: getRelativeHeight(384.0), alignment: .leading)
    //                        .overlay(RoundedCorners(topLeft: 20.0, topRight: 20.0,
    //                                                bottomLeft: 20.0, bottomRight: 20.0)
    //                            .stroke(ColorConstants.WhiteA70033,
    //                                    lineWidth: 1))
    //                        .background(RoundedCorners(topLeft: 20.0, topRight: 20.0,
    //                                                   bottomLeft: 20.0, bottomRight: 20.0)
    //                            .fill(ColorConstants.Bluegray9004c2))
    //                        .shadow(color: ColorConstants.Black9003f, radius: 100, x: 0,
    //                                y: 50)
    //                        .padding(.top, getRelativeHeight(51.0))
    //                        HStack {
    //                            Spacer()
    //                            Image("img_group_white_a700")
    //                                .resizable()
    //                                .frame(width: getRelativeWidth(20.0),
    //                                       height: getRelativeHeight(18.0),
    //                                       alignment: .center)
    //                                .scaledToFit()
    //                                .clipped()
    //                                .padding(.vertical, getRelativeHeight(13.0))
    //                                .padding(.leading, getRelativeWidth(14.0))
    //                                .padding(.trailing, getRelativeWidth(10.0))
    //                            TextField(StringConstants.kMsgMoreFigmaTuto,
    //                                      text: $smallbuttonText)
    //                            .font(FontScheme
    //                                .kRobotoCondensedRegular(size: getRelativeHeight(15.0)))
    //                            .foregroundColor(ColorConstants.WhiteA700)
    //                            .padding()
    //                        }
    //                        .frame(width: getRelativeWidth(220.0),
    //                               height: getRelativeHeight(44.0), alignment: .center)
    //                        .overlay(RoundedCorners(topLeft: 22.0, topRight: 22.0,
    //                                                bottomLeft: 22.0, bottomRight: 22.0)
    //                            .stroke(ColorConstants.Black9004c,
    //                                    lineWidth: 1))
    //                        .background(RoundedCorners(topLeft: 22.0, topRight: 22.0,
    //                                                   bottomLeft: 22.0, bottomRight: 22.0)
    //                            .fill(LinearGradient(gradient: Gradient(colors: [ColorConstants
    //                                .Bluegray9007f,
    //                                                                             ColorConstants
    //                                .Bluegray9007f]),
    //                                                 startPoint: .topLeading,
    //                                                 endPoint: .bottomTrailing)))
    //                        .shadow(color: ColorConstants.Black90026, radius: 40, x: 0,
    //                                y: 20)
    //                        .padding(.top, getRelativeHeight(12.0))
    //                        .padding(.horizontal, getRelativeWidth(48.0))
                }

                .padding()
                
                Spacer()
                
                Button {
                    action()
                } label: {
                    Text(L10n.getStarted)
                        .bold()
                }
                .padding()
                .frame(width: geometry.size.width * 0.7)
                .background(colorScheme == .light ? Color.black : Color.white)
                .cornerRadius(15)
                .shadow(radius: 10)
                .foregroundColor(colorScheme == .light ? Color.white : Color.black)
            }
            .frame(maxWidth: getRect().width * 0.95)
        }
        .background(
            Image("img_waves_1146x768")
                .resizable()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height,
                       alignment: .topLeading)
                .scaledToFit()
                .clipped()
        )
//        .background(
//            HeroParallaxView()
//                .opacity(0.9)
//        )
//        .onAppear {
//            isAnimating.toggle()
//        }
    }
}

struct PermissionView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionView() {}
            .preferredColorScheme(.light)
    }
}
