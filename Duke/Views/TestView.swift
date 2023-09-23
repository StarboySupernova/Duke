//
//  TestView.swift
//  Duke
//
//  Created by user226714 on 9/14/23.
//

import SwiftUI

struct TestView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var smallbuttonText: String = ""
    @State private var frame1159Text: String = ""
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            HStack {
                Button(action: {}, label: {
                    Image("img_logoswiftui")
                })
                .frame(width: getRelativeWidth(44.0),
                       height: getRelativeWidth(44.0), alignment: .center)
                .background(RoundedCorners(topLeft: 22.0, topRight: 22.0,
                                           bottomLeft: 22.0, bottomRight: 22.0)
                    .fill(ColorConstants.Black90087))
                Button(action: {}, label: {
                    Image("img_logofigma")
                })
                .frame(width: getRelativeWidth(44.0),
                       height: getRelativeWidth(44.0), alignment: .center)
                .background(RoundedCorners(topLeft: 22.0, topRight: 22.0,
                                           bottomLeft: 22.0, bottomRight: 22.0)
                    .fill(ColorConstants.Black900))
                .padding(.leading, getRelativeWidth(20.0))
                Button(action: {}, label: {
                    Image("img_logoreact")
                })
                .frame(width: getRelativeWidth(44.0),
                       height: getRelativeWidth(44.0), alignment: .center)
                .background(RoundedCorners(topLeft: 22.0, topRight: 22.0,
                                           bottomLeft: 22.0, bottomRight: 22.0)
                    .fill(ColorConstants.Bluegray901))
                .padding(.leading, getRelativeWidth(20.0))
                Button(action: {}, label: {
                    Image("img_logoframer")
                })
                .frame(width: getRelativeWidth(44.0),
                       height: getRelativeWidth(44.0), alignment: .center)
                .background(RoundedCorners(topLeft: 22.0, topRight: 22.0,
                                           bottomLeft: 22.0, bottomRight: 22.0)
                    .fill(ColorConstants.Black900))
                .padding(.leading, getRelativeWidth(20.0))
            } //logos

            HStack {
                Spacer()
                Image("search")
                    .resizable()
                    .frame(width: getRelativeWidth(20.0),
                           height: getRelativeWidth(20.0), alignment: .center)
                    .scaledToFit()
                    .clipped()
                    .padding(.vertical, getRelativeHeight(12.0))
                    .padding(.horizontal, getRelativeWidth(12.0))
                
                TextField(StringConstants.kLblSearch2, text: $frame1159Text)
                    .foregroundColor(Color.black)
                    .padding()
            } //search bar
            .frame(width: getRelativeWidth(335.0),
                   height: getRelativeHeight(44.0), alignment: .leading)
            .overlay(RoundedCorners(topLeft: 22.0, topRight: 22.0,
                                    bottomLeft: 22.0, bottomRight: 22.0)
                .stroke(Color.white,
                        lineWidth: 1))
            .background(RoundedCorners(topLeft: 22.0, topRight: 22.0,
                                       bottomLeft: 22.0, bottomRight: 22.0)
                .fill(LinearGradient(gradient: Gradient(colors: [ColorConstants
                    .Bluegray5007f,
                                                                 ColorConstants
                    .Bluegray2007f]),
                                     startPoint: .topLeading,
                                     endPoint: .bottomTrailing)))
            .shadow(color: ColorConstants.Black90026, radius: 40, x: 0, y: 20)
            .padding(.top, getRelativeHeight(20.0))
            
            VStack(alignment: .leading, spacing: 0) {
                Text(StringConstants.kLbl30Tutorials)
                    .fontWeight(.medium)
                    .foregroundColor(ColorConstants.WhiteA700B2)
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
                    
                    FloatingButton()
                }
                .frame(width: getRelativeWidth(297.0), alignment: .center)
                .padding(.vertical, getRelativeHeight(8.0))
                .padding(.horizontal, getRelativeWidth(20.0))
            }
            .frame(width: getRelativeWidth(337.0),
                   height: getRelativeHeight(384.0), alignment: .leading)
            .overlay(RoundedCorners(topLeft: 20.0, topRight: 20.0,
                                    bottomLeft: 20.0, bottomRight: 20.0)
                .stroke(ColorConstants.WhiteA70033,
                        lineWidth: 1))
            .background(RoundedCorners(topLeft: 20.0, topRight: 20.0,
                                       bottomLeft: 20.0, bottomRight: 20.0)
                .fill(ColorConstants.Bluegray9004c2))
            .shadow(color: ColorConstants.Black9003f, radius: 100, x: 0,
                    y: 50)
            .padding(.top, getRelativeHeight(51.0))
        }
        .background(
            Image("img_waves_1152x768")
                .resizable()
                .frame(width: UIScreen.main.bounds.width,
                       height: UIScreen.main.bounds.height,
                       alignment: .topLeading)
                .scaledToFit()
                .clipped()
        )
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
            .preferredColorScheme(.light)
    }
}
