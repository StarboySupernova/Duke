//
//  SideBar.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 7/15/23.
//

import SwiftUI

struct SideBar: View {
    var prop: Properties //this should possibly be used in-view, else we can remove
    @State var isDarkMode = false
    @Binding var selectedMenu: SelectedMenu
    
    //should look up scroll solution implemeted earlier in DEMT
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "person.fill")
                    .padding(12)
                    .background(.white.opacity(0.2))
                    .mask(Circle())
                VStack(alignment: .leading, spacing: 2) {
                    Text("Simbarashe Dombodzvuku") //should come from saved name stored in db
                    Text("UI Designer")
                        .font(.subheadline)
                        .opacity(0.7)
                }
                Spacer()
            }
            .padding()
            
            Text("BROWSE")
                .font(.subheadline).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 40)
                .opacity(0.7)
            
            browse
            
            Text("Create")
                .font(.subheadline).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 40)
                .opacity(0.7)
            
            create
            
            Spacer()
            
            HStack(spacing: 14) {
                menuItems3[0].icon.view()
                    .frame(width: 32, height: 32)
                    .opacity(0.6)
                    .onChange(of: isDarkMode) { newValue in
                        if newValue {
                            try? menuItems3[0].icon.setInput("active", value: true)
                        } else {
                            try? menuItems3[0].icon.setInput("active", value: false)
                        }
                    }
                Text(menuItems3[0].text)
                
                Toggle("", isOn: $isDarkMode)
            }
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(8)
        }
        .foregroundColor(.white)
        .frame(maxWidth: 288, maxHeight: .infinity)
        .background(Color(hex: "17203A"))
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color(hex: "17203A").opacity(0.3), radius: 40, x: 0, y: 20)
        .innerShadow(shape:RoundedRectangle(cornerRadius: 30, style: .continuous), color: Color.bottomSheetBorderMiddle, lineWidth: 2, offsetX: 0, offsetY: 2, blur: 0, blendMode: .overlay, opacity: 1)
        .frame(maxWidth: .infinity, alignment: .leading)
        .innerShadow(shape:RoundedRectangle(cornerRadius: 30, style: .continuous), color: Color.bottomSheetBorderMiddle, lineWidth: 2, offsetX: 0, offsetY: 2, blur: 0, blendMode: .overlay, opacity: 1)

    }
    
    var browse: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(menuItems) { item in
                Rectangle()
                    .frame(height: 1)
                    .opacity(0.1)
                    .padding(.horizontal, 16)
                
                HStack(spacing: 14) {
                    item.icon.view()
                        .frame(width: 32, height: 32)
                        .opacity(0.6)
                    Text(item.text)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.blue)
                        .frame(maxWidth: selectedMenu == item.menu ? .infinity : 0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                )
                .background(Color("Background 2"))
                .onTapGesture {
                    withAnimation(.timingCurve(0.2, 0.8, 0.2, 1)) {
                        selectedMenu = item.menu
                    }
                    try? item.icon.setInput("active", value: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        try? item.icon.setInput("active", value: false)
                    }
                }
            }
        }
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
    }
    
    var create: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(menuItems2) { item in
                Rectangle()
                    .frame(height: 1)
                    .opacity(0.1)
                    .padding(.horizontal, 16)
                
                HStack(spacing: 14) {
                    item.icon.view()
                        .frame(width: 32, height: 32)
                        .opacity(0.6)
                    Text(item.text)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.blue)
                        .frame(maxWidth: selectedMenu == item.menu ? .infinity : 0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                )
                .background(Color("Background 2"))
                .onTapGesture {
                    withAnimation(.timingCurve(0.2, 0.8, 0.2, 1)) {
                        selectedMenu = item.menu
                    }
                    try? item.icon.setInput("active", value: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        try? item.icon.setInput("active", value: false)
                    }
                }
            }
        }
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
    }}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        //BookingView()
        HomeView(showSideBar: .constant(false), selectedMenu: .constant(.home))
            .environmentObject(HomeViewModel())
            .preferredColorScheme(.dark)
    }
}
