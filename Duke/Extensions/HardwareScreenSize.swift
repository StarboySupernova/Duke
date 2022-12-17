//
//  HardwareScreenSize.swift
//  D.E.M.Trust
//
//  Created by Simbarashe Dombodzvuku on 11/12/22.
//

import Foundation
import SwiftUI

//does not work well, getRect function works better

private struct MainWindowSizeKey: EnvironmentKey {
    static let defaultValue: CGSize = .zero
}

extension EnvironmentValues {
    var mainWindowSize: CGSize {
        get { self[MainWindowSizeKey.self] }
        set { self[MainWindowSizeKey.self] = newValue }
    }
}
