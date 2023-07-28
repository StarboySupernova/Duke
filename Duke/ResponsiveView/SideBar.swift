//
//  SideBar.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 7/15/23.
//

import SwiftUI

struct SideBar: View {
    var prop: Properties
    @Binding var currentTab: SideMenuTab
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                Label {
                    Text("your profile")
                        .fontWeight(.semibold)
                } icon: {
                    Image("sampleprofileimage")
                        .resizedToFit(width: 15, height: 15)
                }
                .padding(.vertical, 20)
                .padding(.bottom, 15)
                
                Rectangle()
                    .fill(.white.opacity(0.1))
                    .frame(height: 1)
                    .padding(.horizontal, -15)
                
                ForEach(SideMenuTab.allCases, id: \.rawValue) { tab in
                    Button {
                        withAnimation(.easeInOut) {
                            currentTab = tab
                        }
                    } label: {
                        HStack(spacing: 15) {
                            Image(tab.rawValue)
                                .renderingMode(.template)
                                .resizedToFit(width: 25, height: 25)
                            
                            Text(tab.rawValue)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(currentTab == tab ? .green : .white)
                        
                    }
                    .padding(.top)
                }
            }
            .padding(15)
        }
        .frame(width: 220)
        .backgroundBlur(radius: 25, opaque: true)
        .background(Image("Background"))
        .background(Color.bottomSheetBackground)
        .background(.ultraThinMaterial)
        .clipShape(RoundedCorner(radius: 20, corners: [.topRight, .bottomRight]))
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
                .fill(Color.offWhite.opacity(0.9))
                .frame(width: 20, height: 1)
                .frame(height: 20)
                .frame(maxHeight: .infinity, alignment: .top)
        }
    }
    
}

struct SideBar_Previews: PreviewProvider {
    static var previews: some View {
        //BookingView()
        HomeView()
            .environmentObject(HomeViewModel())
            .preferredColorScheme(.dark)
    }
}
