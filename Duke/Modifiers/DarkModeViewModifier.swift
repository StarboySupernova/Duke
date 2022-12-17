//
//  DarkModeViewModifier.swift
//  D.E.M.Trust
//
//  Created by Simbarashe Dombodzvuku on 4/21/22.
//

import Foundation
import SwiftUI

class AppThemeViewModel: ObservableObject {
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = true                           // also exists in DarkModeViewModifier()
    //@AppStorage("appTintColor") var appTintColor: AppTintColorOptions = .indigo
    
}

struct DarkModeViewModifier: ViewModifier {
    @ObservedObject var appThemeViewModel: AppThemeViewModel = AppThemeViewModel()
    
    public func body(content: Content) -> some View {
        content
            .preferredColorScheme(appThemeViewModel.isDarkMode ? .dark : appThemeViewModel.isDarkMode == false ? .light : nil)
            //.accentColor(Color(appThemeViewModel.appTintColor.rawValue))
    }
}
