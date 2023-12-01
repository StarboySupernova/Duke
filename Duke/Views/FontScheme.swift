//
//  FontScheme.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 9/14/23.
//

import Foundation
import SwiftUI

class FontScheme: NSObject {
    static func kRobotoCondensedRegular(size: CGFloat) -> Font {
        return Font.custom(FontConstant.kRobotoCondensedRegular, size: size)
    }

    static func kRobotoCondensedMedium(size: CGFloat) -> Font {
        return Font.custom(FontConstant.kRobotoCondensedMedium, size: size)
    }

    static func kRobotoCondensedBold(size: CGFloat) -> Font {
        return Font.custom(FontConstant.kRobotoCondensedBold, size: size)
    }

    static func kSFProTextRegular(size: CGFloat) -> Font {
        return Font.custom(FontConstant.kSFProTextRegular, size: size)
    }

    static func fontFromConstant(fontName: String, size: CGFloat) -> Font {
        var result = Font.system(size: size)

        switch fontName {
        case "kRobotoCondensedRegular":
            result = self.kRobotoCondensedRegular(size: size)
        case "kRobotoCondensedMedium":
            result = self.kRobotoCondensedMedium(size: size)
        case "kRobotoCondensedBold":
            result = self.kRobotoCondensedBold(size: size)
        case "kSFProTextRegular":
            result = self.kSFProTextRegular(size: size)
        default:
            result = self.kRobotoCondensedRegular(size: size)
        }
        return result
    }

    enum FontConstant {
        /**
         * Please Add this fonts Manually
         */
        static let kRobotoCondensedRegular: String = "RobotoCondensed-Regular"
        /**
         * Please Add this fonts Manually
         */
        static let kRobotoCondensedMedium: String = "RobotoCondensed-Medium"
        /**
         * Please Add this fonts Manually
         */
        static let kRobotoCondensedBold: String = "RobotoCondensed-Bold"
        /**
         * Please Add this fonts Manually
         */
        static let kSFProTextRegular: String = "SFProText-Regular"
    }
}

