//
//  RowCell3.swift
//  Duke
//
//  Created by user226714 on 9/14/23.
//

import SwiftUI

struct Row3Cell: View {
    var body: some View {
        HStack {
            Text(StringConstants.kLbl1)
                .font(FontScheme.kRobotoCondensedRegular(size: getRelativeHeight(20.0)))
                .fontWeight(.regular)
                .padding(.horizontal, getRelativeWidth(13.0))
                .padding(.bottom, getRelativeHeight(6.0))
                .padding(.top, getRelativeHeight(5.0))
                .foregroundColor(Color.white)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
                .frame(width: getRelativeWidth(34.0), height: getRelativeWidth(36.0),
                       alignment: .center)
                .background(ColorConstants.Black9003f)
                .padding(.leading, getRelativeWidth(10.0))
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(StringConstants.kMsgIntroToIosDe)
                        .font(FontScheme.kRobotoCondensedRegular(size: getRelativeHeight(15.0)))
                        .fontWeight(.regular)
                        .foregroundColor(Color.gray)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.leading)
                        .frame(width: getRelativeWidth(131.0), height: getRelativeHeight(18.0),
                               alignment: .leading)
                    Spacer()
                    Text(StringConstants.kLbl608)
                        .font(FontScheme.kRobotoCondensedRegular(size: getRelativeHeight(13.0)))
                        .fontWeight(.regular)
                        .padding(.horizontal, getRelativeWidth(6.0))
                        .foregroundColor(Color.white)
                        .minimumScaleFactor(0.5)
                        .multilineTextAlignment(.center)
                        .frame(width: getRelativeWidth(39.0), height: getRelativeHeight(20.0),
                               alignment: .center)
                        .background(ColorConstants.Black9003f)
                }
                .frame(width: getRelativeWidth(227.0), height: getRelativeHeight(20.0),
                       alignment: .leading)
                VStack {
                    ZStack {}
                        .hideNavigationBar()
                        .frame(width: getRelativeWidth(20.0), height: getRelativeHeight(3.0),
                               alignment: .leading)
                        .background(RoundedCorners(topLeft: 1.5, topRight: 1.5, bottomLeft: 1.5,
                                                   bottomRight: 1.5)
                            .fill(Color.white))
                        .padding(.trailing, getRelativeWidth(147.0))
                }
                .frame(width: getRelativeWidth(168.0), height: getRelativeHeight(5.0),
                       alignment: .leading)
                .background(RoundedCorners(topLeft: 2.0, topRight: 2.0, bottomLeft: 2.0,
                                           bottomRight: 2.0)
                        .fill(ColorConstants.Black9003f))
                .padding(.top, getRelativeHeight(8.0))
                .padding(.trailing, getRelativeWidth(10.0))
                Text(StringConstants.kMsgDesignAnIosA)
                    .font(FontScheme.kRobotoCondensedRegular(size: getRelativeHeight(13.0)))
                    .fontWeight(.regular)
                    .foregroundColor(Color.gray)
                    .minimumScaleFactor(0.5)
                    .multilineTextAlignment(.leading)
                    .frame(width: getRelativeWidth(213.0), height: getRelativeHeight(33.0),
                           alignment: .leading)
                    .padding(.top, getRelativeHeight(8.0))
                    .padding(.trailing, getRelativeWidth(10.0))
            }
            .frame(width: getRelativeWidth(227.0), height: getRelativeHeight(75.0),
                   alignment: .leading)
            .padding(.horizontal, getRelativeWidth(10.0))
        }
        .frame(width: getRelativeWidth(295.0), alignment: .leading)
        .background(RoundedCorners(topLeft: 10.0, topRight: 10.0, bottomLeft: 10.0,
                                   bottomRight: 10.0)
            .fill(Color.white))
        .shadow(color: Color.black, radius: 0, x: 0, y: 0)
        .hideNavigationBar()
    }
}

struct RowCell3_Previews: PreviewProvider {
    static var previews: some View {
        Row3Cell()
    }
}
