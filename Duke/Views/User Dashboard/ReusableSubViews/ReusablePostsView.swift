//
//  ReusablePostsView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/2/23.
//

import SwiftUI
import Firebase

/// To eliminate redundant code since we have to display the current user's posts on screen and display another user's posts when searching for that user
struct ReusablePostsView: View {
    var basedOnUID: Bool = false
    var uid: String = ""
    @State var isFetching: Bool = false
    @Binding var posts : [Post]
    ///Pagination
    @State private var paginationDoc: QueryDocumentSnapshot?
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVStack { //LazyVStack allows us to receive notifications via onAppear and onDisappear when child views move outside the screen
                if isFetching {
                    ProgressView()
                        .padding(.top, .xxLarge)
                } else {
                    if posts.isEmpty {
                        Text("Feed empty, and waiting for you. Create new content now")
                            .font(.callout)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.gray)
                            .padding(.top, .xxLarge)
                    } else {
                        Posts()
                    }
                }
            }
            .padding(.large)
        }
        .refreshable {
            //refreshing for posts fetched by UID not supported
            guard !basedOnUID else { return }
            isFetching = true
            posts = []
            //resetting pagination doc for refreshes since refresh will fetch most recent posts, hence paginationdoc needs to be updated
            paginationDoc = nil
            await fetchPosts()
        }
        .task {
            //running fetch operation only when internalPosts has no values
            guard posts.isEmpty else  { return }
            await fetchPosts()
        }
    }
    
    /// Displayiing fetched posts
    @ViewBuilder func Posts() -> some View {
        ForEach(posts) { post in
            UserPostCardView(post: post) { updatedPost in
                //updating post in array
                if let index = posts.firstIndex(where: { post in
                    post.id == updatedPost.id
                }) {
                    posts[index].upvoteIDs = updatedPost.upvoteIDs
                    posts[index].downvoteIDs = updatedPost.downvoteIDs
                }
            } onDelete: {
                //removing post from array
                withAnimation(.easeInOut(duration: 0.25)) {
                    posts.removeAll {
                        post.id == $0.id
                    }
                }
            }
            .onAppear {
                //MARK: we null-check pagination here as well, so that when each batch fetch is completed, we will no longer run fetch operation when last document has been reached. This is an infinite scroll feature, which will not overwhelm our db capabilities with I/O operations. Fetch operations run only after user scrolls to the end of previous batch
                if post.id == posts.last?.id && paginationDoc != nil {
                    Task {
                        await fetchPosts()
                    }
                }
            }

            Divider()
                .padding(.horizontal, -15)
        }
    }
    
    //should find a way to use this while following MVVM pattern
    
    /// asynchronously fetching posts
    /// will run fetch operation for recent posts, or for a specific userUID based on the Boolean value of basedOnUID
    func fetchPosts() async {
        do {
            var query: Query!
            ///implementing pagination
            if paginationDoc != nil {
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .start(afterDocument: paginationDoc!)
                    .limit(to: 20)
            } else {
                query = Firestore.firestore().collection("Posts")
                    .order(by: "publishedDate", descending: true)
                    .limit(to: 20)
            }
            
            /// new query for UID based fetch operation, by filtering out posts not attached to the passed-in UID
            if basedOnUID {
                query = query.whereField("userUID", isEqualTo: uid)
            }
            
            let docs = try await query.getDocuments()
            let fetchedPosts = try docs.documents.compactMap { document -> Post in
                try document.data(as: Post.self)
            } 
            
            //saving last fetched doc so that it can be used for pagination in Firestore
            await MainActor.run(body: {
                posts.append(contentsOf: fetchedPosts)
                paginationDoc = docs.documents.last
                isFetching = false
            })
        } catch {
            showErrorAlertView("Error", error.localizedDescription, handler: {})
        }
    }
}

struct ReusablePostsView_Previews: PreviewProvider {
    static var previews: some View {
        PostsView()
            .preferredColorScheme(.dark)
    }
}
