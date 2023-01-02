//
//  PostsView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/2/23.
//

import SwiftUI

struct PostsView: View {
    @State private var recentPosts: [Post] = []
    @State private var createNewPost: Bool = false
    var body: some View {
        if #available(iOS 16.0, *) {
            NavigationStack {
                ReusablePostsView(posts: $recentPosts)
                    .horizontalAlign(.center)
                    .verticalAlign(.center)
                    .overlay(alignment: .bottomTrailing) {
                        Button {
                            createNewPost.toggle()
                        } label: {
                            Image(systemName: "plus")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(.large)
                                .background(.black, in: Circle())
                        }
                        .padding(.large)
                    }
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink {
                                SearchUserView()
                            } label: {
                                Image(systemName: "magnifyingglass")
                                    .tint(.black)
                                    .scaleEffect(0.9)
                            }

                        }
                    })
                    .navigationTitle("Posts")
            }
            .fullScreenCover(isPresented: $createNewPost) {
                createNewPost = false
            } content: {
                NewPost { post in //should use environmentObject here
                    //insert created post at the top on the recent posts list
                    recentPosts.insert(post, at: 0)
                }
                .environmentObject(PostViewModel()) //iffy. defining enviromnetObject on modal sheet
            }
        } else {
            // Fallback on earlier versions
        }
        
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
    }
}
