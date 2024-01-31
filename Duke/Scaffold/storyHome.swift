//
//  storyHome.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/31/24.
//

import Foundation
import SwiftUI

struct StoryHomeView: View {
    @State private var index = 0
    @State private var stories: [Story] = [
        Story(id: 1, image: "background1", offset: 10, title: "Title 1"),
//        Story(id: 2, image: "background2", offset: -20, title: "Title 2"),
        Story(id: 3, image: "background3", offset: 5, title: "Title 3"),
//        Story(id: 4, image: "background4", offset: -15, title: "Title 4"),
        Story(id: 5, image: "background5", offset: 30, title: "Title 5"),
//        Story(id: 6, image: "background6", offset: -10, title: "Title 6"),
        Story(id: 7, image: "background7", offset: 0, title: "Title 7")
    ]
    @State private var scrolled = 0
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                HStack {
                    Button {
                        
                    } label: {
                        Image("menu")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                    }
                    Spacer()
                    
                    Button(action: {}) {
                        Image("search")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                
                HStack {
                    Text("Trending")
                        .font(.system(size: 40,weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Spacer(minLength: 0)
                    
                    Button(action: {}) {
                        Image("dots")
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .rotationEffect(.init(degrees: 90))
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Animated")
                        .font(.caption)
                        .foregroundColor(index == 0 ? .white : Color("Background 1").opacity(0.85))
                        .fontWeight(.bold)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 20)
                        .background(Color("Background").opacity(index == 0 ? 1 : 0))
                        .clipShape(Capsule())
                        .onTapGesture {
                            index = 0
                        }
                    
                    Text("25+ Series")
                        .font(.caption)
                        .foregroundColor(index == 1 ? .white : Color("Background 1").opacity(0.85))
                        .fontWeight(.bold)
                        .padding(.vertical, 6)
                        .padding(.horizontal, 20)
                        .background(Color("cyan").opacity(index == 0 ? 1 : 0))
                        .clipShape(Capsule())
                        .onTapGesture {
                            index = 1
                        }
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                //Card View
                ZStack{
                    //ZStack will overlap views so last will become first
                    ForEach(stories.reversed()) { story in
                        HStack {
                            ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)){
                                Image(story.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                //dynamic frame
                                //dynamic height
                                    .frame(width:calculateWidth(), height: calculateHeight(for: story.id, scrolled: scrolled))
                                    .cornerRadius(15)
                                
                                VStack(alignment: .leading, spacing: 18){
                                    HStack {
                                        Text(story.title)
                                            .font(.title)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                        
                                        Spacer()
                                    }
                                    
                                    Button(action: {}) {
                                        Text("Read Later")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.vertical, 6)
                                            .padding(.horizontal, 25)
                                            .background(Color("Background 1"))
                                            .clipShape(Capsule())
                                    }
                                }
                                .frame(width: calculateWidth() - 40)
                                .padding(.leading, 20)
                                .padding(.bottom, 20)
                            }
                            .offset(x: story.id - scrolled <= 2 ? CGFloat(story.id - scrolled) * 30 : 60)
                            
                            Spacer(minLength: 0)
                        }
                        .contentShape(Rectangle())
                        // adding gesture
                        .offset(x: story.offset)
                        .gesture(DragGesture().onChanged({(value) in
                            withAnimation {
                                //disabling drag for last card
                                if value.translation.width < 0 && story.id != stories.last!.id {
                                    stories[story.id].offset = value.translation.width
                                } else {
                                    //restoring cards
                                    if story.id > 0 {
                                        stories[story.id - 1].offset = -(calculateWidth() + 60) + value.translation.width
                                    }
                                }
                            }
                        }).onEnded({(value) in
                            withAnimation {
                                if value.translation.width < 0 {
                                    if -value.translation.width > 180 && story.id != stories.last!.id {
                                        //moving view away
                                        stories[story.id].offset = -(calculateWidth() + 60)
                                        scrolled += 1
                                    } else {
                                        stories[story.id].offset = 0
                                    }
                                } else {
                                    //restoring card
                                    if story.id > 0 {
                                        if value.translation.width > 180 {
                                            stories[story.id - 1].offset = 0
                                            scrolled -= 1
                                        } else {
                                            stories[story.id - 1].offset = -(calculateWidth() + 60)
                                        }
                                    }
                                }
                            }
                        }))
                    }
                    
                }
                //max height
                .frame(height: UIScreen.main.bounds.height / 1.8)
                .padding(.horizontal, 25)
                .padding(.top, 25)
                
                Spacer()
            }
        }
        .background (
            LinearGradient(gradient: .init(colors: [Color("Background"), Color("cyan")]),startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    func calculateWidth() -> CGFloat {
        let screen = UIScreen.main.bounds.width - 50
        
        //showing first 3 cards. all the others will be hidden
        let width = screen - (2 * 30)
        
        return width
    }
    
    func calculateHeight(for id: Int, scrolled: Int) -> CGFloat {
        let baseHeight = (UIScreen.main.bounds.height / 1.8)
        let adjustedHeight = baseHeight - CGFloat(id - scrolled) * 50
        return adjustedHeight
    }
}

struct StoryHome_Previews: PreviewProvider {
    static var previews: some View {
        StoryHomeView()
    }
}

struct Story: Identifiable {
    var id: Int
    var image: String
    var offset: CGFloat
    var title: String
}


