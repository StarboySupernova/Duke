//
//  ExtensionOnImage.swift
//  D.E.M.Trust
//
//  Created by Simbarashe Dombodzvuku on 4/21/22.
//

import Foundation
import SwiftUI

extension Image {
    
    /// Resize an image with fill aspect ratio and specified frame dimensions.
    ///   - parameters:
    ///     - width: Frame width.
    ///     - height: Frame height.
    func resizedToFill(width: CGFloat, height: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: width, height: height)
    }
    
    /// Resize an image with fit aspect ratio and specified frame dimensions.
    ///   - parameters:
    ///     - width: Frame width.
    ///     - height: Frame height.
    func resizedToFit(width: CGFloat, height: CGFloat) -> some View {
        self
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
    }
    
    /// Resize an image with fill aspect ratio, customizable aspect ratio value (default: 4/3) and specified frame dimensions.
    ///   - parameters:
    ///     - width: Frame width.
    ///     - height: Frame height.
    ///     - aspectRatio: value to pass to aspectRatio, if any
    func resizedToFillAspectRatio(width: CGFloat, height: CGFloat, aspectRatio: CGFloat = 4/3) -> some View {
        self
            .resizable()
            .aspectRatio(aspectRatio, contentMode: .fill)
            .frame(width: width, height: height)
    }
    
    /// Resize an image with fit aspect ratio, customizable aspect ratio value (default: 4/3) and specified frame dimensions.
    ///   - parameters:
    ///     - width: Frame width.
    ///     - height: Frame height.
    ///     - aspectRatio: value to pass to aspectRatio, if any
    func resizedToFitAspectRatio(width: CGFloat, height: CGFloat, aspectRatio: CGFloat = 4/3) -> some View {
        self
            .resizable()
            .aspectRatio(aspectRatio, contentMode: .fit)
            .frame(width: width, height: height)
    }
}
