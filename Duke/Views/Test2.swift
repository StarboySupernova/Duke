//
//  Test2.swift
//  Duke
//
//  Created by user226714 on 9/15/23.
//

import SwiftUI

struct Test2: View {
    @State private var frame1159Text: String = ""
    
    var body: some View {
        ZStack(alignment: .center) {
            Image("img_waves_1152x768")
                .resizable()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height,
                       alignment: .topLeading)
                .scaledToFit()
                .clipped()
            ScrollView {
                VStack {
                    ZStack(alignment: .topLeading) {
                        ZStack {}
                            .hideNavigationBar()
                            .frame(width: getRelativeWidth(240.0),
                                   height: getRelativeHeight(307.0),
                                   alignment: .leading)
                            .background(RoundedCorners(topRight: 60.0,
                                                       bottomLeft: 40.0,
                                                       bottomRight: 40.0)
                                .fill(LinearGradient(gradient: Gradient(colors: [ColorConstants
                                    .RedA200,
                                                                                 ColorConstants
                                    .PinkA100]),
                                                     startPoint: .topLeading,
                                                     endPoint: .bottomTrailing)))
                            .shadow(color: ColorConstants.Black9003f, radius: 40,
                                    x: 0, y: 20)
                        
                        ZStack(alignment: .topTrailing) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(StringConstants.kLblFeatured)
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
                                Text("Duke")
                                    .font(FontScheme
                                        .kRobotoCondensedBold(size: getRelativeHeight(24.0)))
                                    .fontWeight(.bold)
                                    .foregroundColor(Color.white)
                                    .minimumScaleFactor(0.5)
                                    .multilineTextAlignment(.leading)
                                    .frame(width: getRelativeWidth(160.0),
                                           height: getRelativeHeight(58.0),
                                           alignment: .topLeading)
                                    .shadow(color: ColorConstants.Black9003f,
                                            radius: 40, x: 0, y: 20)
                                    .padding(.top, getRelativeHeight(10.0))
                                    .padding(.trailing, getRelativeWidth(10.0))
                                Text(StringConstants.kMsgAComprehensive2)
                                    .font(FontScheme
                                        .kRobotoCondensedRegular(size: getRelativeHeight(13.0)))
                                    .fontWeight(.regular)
                                    .foregroundColor(Color.white)
                                    .minimumScaleFactor(0.5)
                                    .multilineTextAlignment(.leading)
                                    .frame(width: getRelativeWidth(160.0),
                                           height: getRelativeHeight(52.0),
                                           alignment: .topLeading)
                                    .padding(.top, getRelativeHeight(10.0))
                                    .padding(.trailing, getRelativeWidth(10.0))
                                HStack {
                                    Button(action: {}, label: {
                                        Image("img_largeiconfile_white_a700")
                                    })
                                    .frame(width: getRelativeWidth(31.0),
                                           height: getRelativeHeight(32.0),
                                           alignment: .center)
                                    .background(RoundedCorners(topLeft: 16.0,
                                                               topRight: 16.0,
                                                               bottomLeft: 16.0,
                                                               bottomRight: 16.0)
                                        .fill(ColorConstants.Black9003f))
                                    Text(StringConstants.kMsg30FreeTutoria)
                                        .font(FontScheme
                                            .kRobotoCondensedRegular(size: getRelativeHeight(13.0)))
                                        .fontWeight(.regular)
                                        .foregroundColor(Color.white)
                                        .minimumScaleFactor(0.5)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: getRelativeWidth(99.0),
                                               height: getRelativeHeight(16.0),
                                               alignment: .topLeading)
                                        .padding(.top, getRelativeHeight(7.0))
                                        .padding(.bottom, getRelativeHeight(8.0))
                                        .padding(.leading, getRelativeWidth(10.0))
                                }
                                .frame(width: getRelativeWidth(141.0),
                                       height: getRelativeHeight(32.0),
                                       alignment: .leading)
                                .padding(.top, getRelativeHeight(8.0))
                                .padding(.trailing, getRelativeWidth(10.0))
                                HStack {
                                    Button(action: {}, label: {
                                        Image("img_arrowleft_white_a700_32x31")
                                    })
                                    .frame(width: getRelativeWidth(31.0),
                                           height: getRelativeHeight(32.0),
                                           alignment: .center)
                                    .background(RoundedCorners(topLeft: 16.0,
                                                               topRight: 16.0,
                                                               bottomLeft: 16.0,
                                                               bottomRight: 16.0)
                                        .fill(ColorConstants.Black9003f))
                                    Spacer()
                                    Text(StringConstants.kMsgVideosPdfFi)
                                        .font(FontScheme
                                            .kRobotoCondensedRegular(size: getRelativeHeight(13.0)))
                                        .fontWeight(.regular)
                                        .foregroundColor(Color.white)
                                        .minimumScaleFactor(0.5)
                                        .multilineTextAlignment(.leading)
                                        .frame(width: getRelativeWidth(107.0),
                                               height: getRelativeHeight(16.0),
                                               alignment: .topLeading)
                                        .padding(.top, getRelativeHeight(8.0))
                                        .padding(.bottom, getRelativeHeight(7.0))
                                    Spacer()
                                    Text(StringConstants.kLblPro)
                                        .font(FontScheme
                                            .kRobotoCondensedMedium(size: getRelativeHeight(13.0)))
                                        .fontWeight(.medium)
                                        .padding(.horizontal, getRelativeWidth(6.0))
                                        .foregroundColor(Color.white)
                                        .minimumScaleFactor(0.5)
                                        .multilineTextAlignment(.center)
                                        .frame(width: getRelativeWidth(40.0),
                                               height: getRelativeHeight(20.0),
                                               alignment: .center)
                                        .background(ColorConstants.Black9003f)
                                        .padding(.vertical, getRelativeHeight(6.0))
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
                            
                            Button(action: {}, label: {
                                Image("img_logofigma")
                            })
                            .frame(width: getRelativeWidth(32.0),
                                   height: getRelativeWidth(32.0),
                                   alignment: .center)
                            .background(RoundedCorners(topLeft: 16.0,
                                                       topRight: 16.0,
                                                       bottomLeft: 16.0,
                                                       bottomRight: 16.0)
                                .fill(Color.black))
                            .padding(.bottom, getRelativeHeight(228.0))
                            .padding(.leading, getRelativeWidth(188.0))
                        }
                        .frame(width: getRelativeWidth(240.0),
                               height: getRelativeHeight(280.0),
                               alignment: .topLeading)
                        .overlay(RoundedCorners(topRight: 30.0, bottomLeft: 40.0,
                                                bottomRight: 40.0)
                            .stroke(Color.white.opacity(0.2),
                                    lineWidth: 1))
                        .background(RoundedCorners(topRight: 30.0, bottomLeft: 40.0,
                                                   bottomRight: 40.0)
                            .fill(Color.black.opacity(0.1)))
                        .shadow(radius: 40)
                        .padding(.bottom, getRelativeHeight(28.0))
                    }
                    .frame(width: getRelativeWidth(240.0),
                           height: getRelativeHeight(308.0), alignment: .center)
                    .padding(.horizontal, getRelativeWidth(48.0))
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(StringConstants.kLbl30Tutorials)
                            .font(FontScheme
                                .kRobotoCondensedMedium(size: getRelativeHeight(13.0)))
                            .fontWeight(.medium)
                            .foregroundColor(Color.white)
                            .minimumScaleFactor(0.5)
                            .multilineTextAlignment(.leading)
                            .frame(width: getRelativeWidth(96.0),
                                   height: getRelativeHeight(16.0),
                                   alignment: .topLeading)
                            .padding(.top, getRelativeHeight(20.0))
                            .padding(.horizontal, getRelativeWidth(20.0))
                        VStack(spacing: 0) {
                            ScrollView(.vertical, showsIndicators: false) {
                                LazyVStack {
                                    ForEach(0 ... 2, id: \.self) { index in
                                        Row3Cell()
                                    }
                                }
                            }
                        }
                        .frame(width: getRelativeWidth(297.0), alignment: .center)
                        .padding(.vertical, getRelativeHeight(8.0))
                        .padding(.horizontal, getRelativeWidth(20.0))
                    }
                    .frame(width: getRelativeWidth(337.0),
                           height: getRelativeHeight(384.0), alignment: .leading)
                    .overlay(RoundedCorners(topLeft: 20.0, topRight: 20.0,
                                            bottomLeft: 20.0, bottomRight: 20.0)
                        .stroke(Color.white,
                                lineWidth: 1))
                    .background(RoundedCorners(topLeft: 20.0, topRight: 20.0,
                                               bottomLeft: 20.0, bottomRight: 20.0)
                        .fill(ColorConstants.Bluegray2007f))
                    .shadow(color: ColorConstants.Black9003f, radius: 100, x: 0,
                            y: 50)
                    .padding(.top, getRelativeHeight(51.0))
                    
                    HStack {
                        Spacer()
                        Image("insight")
                            .resizable()
                            .frame(width: getRelativeWidth(20.0),
                                   height: getRelativeHeight(18.0),
                                   alignment: .center)
                            .scaledToFit()
                            .clipped()
                            .padding(.vertical, getRelativeHeight(13.0))
                            .padding(.leading, getRelativeWidth(14.0))
                            .padding(.trailing, getRelativeWidth(10.0))
                        
                        TextField(StringConstants.kMsgMoreFigmaTuto,
                                  text: $frame1159Text)
                        .font(FontScheme
                            .kRobotoCondensedRegular(size: getRelativeHeight(15.0)))
                        .foregroundColor(Color.white)
                        .padding()
                    }
                    .frame(width: getRelativeWidth(220.0),
                           height: getRelativeHeight(44.0), alignment: .center)
                    .overlay(RoundedCorners(topLeft: 22.0, topRight: 22.0,
                                            bottomLeft: 22.0, bottomRight: 22.0)
                        .stroke(ColorConstants.Black9003f,
                                lineWidth: 1))
                    .background(RoundedCorners(topLeft: 22.0, topRight: 22.0,
                                               bottomLeft: 22.0, bottomRight: 22.0)
                        .fill(LinearGradient(gradient: Gradient(colors: [ColorConstants
                            .Bluegray5007f,
                                                                         ColorConstants
                            .Bluegray5007f]),
                                             startPoint: .topLeading,
                                             endPoint: .bottomTrailing)))
                    .shadow(color: ColorConstants.Black90026, radius: 40, x: 0,
                            y: 20)
                    .padding(.top, getRelativeHeight(12.0))
                    .padding(.horizontal, getRelativeWidth(48.0))
                }
            }
            
        }
        
        
    }
}

struct Test2_Previews: PreviewProvider {
    static var previews: some View {
        Test2()
    }
}
