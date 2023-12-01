//
//  ResponsiveView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 7/15/23.
//

import SwiftUI

struct ResponsiveView<Content:View> : View {
    var content: (Properties) -> Content

    var body: some View {
        GeometryReader{ geometry in
            let size = geometry.size
            let isLandscape = (size.width > size.height)
            let isiPad = UIDevice.current.userInterfaceIdiom == .pad

            content(Properties(isLandscape: isLandscape, isiPad: isiPad, isSplit: isSplit(), size: size))
                .frame(width:size.width, height:size.height, alignment: .center)
                .onAppear {
                    updateFraction(fraction: isLandscape && !isSplit() ? 0.3 : 0.5)
                }
                .onChange(of: isSplit()) { newValue in
                    updateFraction(fraction: isLandscape && !isSplit() ? 0.3 : 0.5)
                }
                .onChange(of: isLandscape) { newValue in
                    updateFraction(fraction: newValue && !isSplit() ? 0.3 : 0.5)
                }

        }
    }

    //UI should appear as expected when app is split
    func isSplit() -> Bool {
        //iffy
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return false
        }

        return screen.windows.first?.frame.size != UIScreen.main.bounds.size
    }

    func updateFraction(fraction: Double) {
        NotificationCenter.default.post(name: NSNotification.Name("UPDATEFRACTION"), object: nil, userInfo: [
            "fraction" : fraction
        ])
    }
}

struct ResponsiveView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(showSideBar: .constant(false), selectedMenu: .constant(.home), expandedTrends: .constant(false), showTrends: .constant(true))
    }
}
