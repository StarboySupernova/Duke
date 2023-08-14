//
//  VerticalContentView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 8/14/23.
//

import SwiftUI

struct VerticalContentView: View {
    @State var verticalTabSelection: Tab = .chat
    @Binding var selectedMenu: SelectedMenu
    
    var body: some View {
        ResponsiveView { prop in
            HStack(spacing: 0) {
                //displaying only on iPad and not on split mode
                if prop.isiPad && !prop.isSplit {
                    SideBar(prop: prop, selectedMenu: $selectedMenu)
                }
                
                TabView(selection: $verticalTabSelection) {
                    
                }
            }
        }
    }
}

struct VerticalContentView_Previews: PreviewProvider {
    static var previews: some View {
        VerticalContentView(selectedMenu: .constant(.home))
    }
}
