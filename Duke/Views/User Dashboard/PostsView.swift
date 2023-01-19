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
        
        //MARK: iOS 16 code
        /*if #available(iOS 16.0, *) {
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
                                .background(.pink, in: Circle())
                        }
                        .padding(.large)
                    }
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            NavigationLink {
                                SearchUserView()
                            } label: {
                                Image(systemName: "magnifyingglass")
                                    .tint(.pink)
                                    .scaleEffect(0.9)
                            }
                            
                        }
                    })
                    .navigationTitle("Feed")
            }
            .fullScreenCover(isPresented: $createNewPost) {
                createNewPost = false
            } content: {
                NewPost { post in
                    //insert created post at the top on the recent posts list
                    recentPosts.insert(post, at: 0)
                }
                .environmentObject(PostViewModel()) //iffy. defining enviromnetObject on modal sheet
            }
        } else {
            // Fallback on earlier versions
        }*/
        #warning("ChatGPT Generated")
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    Text("Feed")
                        .foregroundColor(.white)
                    Spacer()
                    Image(systemName: "magnifyingglass")
                        .tint(.pink)
                        .scaleEffect(0.9)
                        .contentShape(Rectangle())
                }
                .padding(.medium)
                Divider()

                Spacer()
                
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
                                .background(.pink, in: Circle())
                        }
                        .padding(.large)
                    }
            }
            .fullScreenCover(isPresented: $createNewPost) {
                createNewPost = false
            } content: {
                NewPost { post in
                    //insert created post at the top on the recent posts list
                    recentPosts.insert(post, at: 0)
                }
                .environmentObject(PostViewModel()) //iffy. defining enviromnetObject on modal sheet
            }
        }
    }
}

struct PostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
            .preferredColorScheme(.dark)
    }
}
