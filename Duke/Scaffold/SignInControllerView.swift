//
//  SignInControllerView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 4/25/23.
//

import SwiftUI

struct SignInControllerView: View {
    @EnvironmentObject var userLoginVM: UserViewModel
    var bottomSheetTranslationProrated: CGFloat = 1
    @State private var selection = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // MARK: Segmented Control
            SegmentedControl(selection: $selection) //should use this also inside tabview
            
            // MARK: Nested Views
            HStack(spacing: 12) {
                if selection == 0 {
                    //pass selection as a binding into these views
                    LoginView(selection: $selection)
                        .transition(.offset(x: -getRect().width))
                } else {
                    RegistrationView(selection: $selection)
                        .transition(.offset(x: getRect().width))
                }
            }
            .padding(.vertical, 20)
        
        }
        .backgroundBlur(radius: 25, opaque: true)
        .background(Image("Background"))
        .background(Color.bottomSheetBackground)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 44))
        .innerShadow(shape: RoundedRectangle(cornerRadius: 44), color: Color.bottomSheetBorderMiddle, lineWidth: 1, offsetX: 0, offsetY: 1, blur: 0, blendMode: .overlay, opacity: 1 - bottomSheetTranslationProrated)
        .overlay {
            // MARK: Bottom Sheet Separator
            Divider()
                .blendMode(.overlay)
                .background(Color.bottomSheetBorderTop)
                .frame(maxHeight: .infinity, alignment: .top)
                .clipShape(RoundedRectangle(cornerRadius: 44))
        }
        .overlay {
            // MARK: Drag Indicator
            RoundedRectangle(cornerRadius: 10)
                .fill(.black.opacity(0.3))
                .frame(width: 48, height: 5)
                .frame(height: 20)
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

struct SignInControllerView_Previews: PreviewProvider {
    static var previews: some View {
        SignInControllerView()
            //.background(Color.background)
            .preferredColorScheme(.dark)
            .environmentObject(UserViewModel())
    }
}
