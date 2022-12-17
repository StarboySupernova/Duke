//
//  ExtensionOnLinearGradient.swift
//  D.E.M.Trust
//
//  Created by Simbarashe Dombodzvuku on 4/20/22.
//

import Foundation
import SwiftUI

extension LinearGradient {
    //named initializer to differentiate from build in (_color:) initializer
    init(mycolors: Color...){
        self.init(gradient: Gradient(colors: mycolors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

