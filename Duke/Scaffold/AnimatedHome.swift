//
//  AnimatedHome.swift
//  Duke
//
//  Created by user226714 on 8/4/23.
//

import SwiftUI

struct AnimatedHomeView: View {
    var body: some View {
        ZStack {
            Color("Background 1").ignoresSafeArea()
            
            ScrollView {
                content
            }
        }
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Courses")
                    .font(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(courses) { course in
                        VCard(course: course)
                    }
                }
                .padding(20)
                .padding(.bottom, 10)
            }
            
            VStack {
                Text("Recent")
                    .font(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 20) {
                    ForEach(courseSections) { section in
                        HCard(section: section)
                    }
                }
            }
            .padding(20)
        }
    }
}

struct AnimatedHomeView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedHomeView()
    }
}
