//
//  Corners.swift
//  D.E.M.Trust
//
//  Created by Simbarashe Dombodzvuku on 10/11/22.
//

import Foundation
import SwiftUI

struct Corners: Shape {
    var corner: UIRectCorner
    var size: CGSize
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corner, cornerRadii: size)
        return Path(path.cgPath)
    }
}

