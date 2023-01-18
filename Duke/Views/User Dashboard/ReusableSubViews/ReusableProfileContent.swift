//
//  ReusableProfileContent.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/2/23.
//

import SwiftUI

struct ReusableProfileContent: View {
    var user: User
    @State private var isShowingPhotoPicker : Bool = false
    @State private var avatar: UIImage? = nil
    @State private var fetchedPosts : [Post] = []
    //may need a binding to status here
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack {
                HStack(spacing: .medium) {
                    #warning("change default image here")
                    Image(uiImage: /*(status) ?*/ avatar ?? userProvidedImage("user_Image") ?? UIImage.init(named: "chef")! /*: UIImage.init(named: "usericon")!*/)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .cornerRadius(10)
                        .padding(.top, .xxLarge)
                        .onTapGesture {
                            #warning("haven't defined status yet from UserDefaults")
                            /*if status {
                                isShowingPhotoPicker = true
                            }*/
                        }
                        .sheet(isPresented: $isShowingPhotoPicker) {
                            //status = false - may not be needed
                            isShowingPhotoPicker = false
                            //status = true
                        } content: {
                            PhotoPicker(avatar: $avatar)
                        }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text(user.userName)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        Text(user.userBio)
                            .font(.caption)
                            .foregroundColor(.gray)
                            .lineLimit(3)
                        
                        if let bioLink = URL(string: user.userBioLink) {
                            Link(user.userBioLink, destination: bioLink)
                                .font(.callout)
                                .tint(.customOrange)
                                .lineLimit(1)
                        }
                    }
                    .horizontalAlign(.leading)
                }
                
                Text("Posts")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .horizontalAlign(.leading)
                    .padding(.vertical, .large)
                
                //reduced redundancy here through ReusablePostsView
                ReusablePostsView(basedOnUID: true, uid: user.userUID, posts: $fetchedPosts)
            }
            .padding(.large)
        }
    }
}
