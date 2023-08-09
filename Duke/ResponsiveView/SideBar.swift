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
                        .resizedToFill(width: 50, height: 50)
                        .clipShape(RoundedCorner(radius: 20, corners: [.topRight, .bottomLeft]))
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
                        TitleCard(isActive: tab == currentTab, headingText: tab.rawValue, imageName: "")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.top, .medium)
                }
            }
            .padding(15)
        }
        .frame(width: 220)
        .backgroundBlur(radius: 25, opaque: true)
        .background(Color.background)
        .background(.ultraThinMaterial)
        .clipShape(RoundedCorner(radius: 20, corners: [.topRight, .bottomRight]))
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
        HomeView(showSideBar: .constant(false))
            .environmentObject(HomeViewModel())
            .preferredColorScheme(.dark)
    }
}
