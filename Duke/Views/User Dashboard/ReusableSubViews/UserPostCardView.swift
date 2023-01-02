//
//  UserPostCardView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/2/23.
//

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseStorage

struct UserPostCardView: View {
    ///for live updates
    @State private var docListener: ListenerRegistration?
    var post: Post
    ///callbacks
    var onUpdate: (Post) -> ()
    var onDelete: () -> ()
    var body: some View {
        HStack(alignment: .top, spacing: .medium) {
            Image(uiImage: /*(status) ?*/ userProvidedImage("user_Image") ?? UIImage.init(named: "DEMTLogo")! /*: UIImage.init(named: "usericon")!*/)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 35, height: 35)
                .cornerRadius(10)
                .padding(.top, .large)
            
            VStack(alignment: .leading, spacing: .small) {
                Text(post.userName)
                    .font(.callout)
                    .fontWeight(.semibold)
                Text(post.publishedDate.formatted(date: .numeric, time: .shortened)) //add condition check to make this .standard if one week elapses
                    .font(.caption2)
                    .foregroundColor(.gray)
                Text(post.text)
                    .textSelection(.enabled)
                    .padding(.vertical, .medium)
                
                if let postImageURL = post.imageURL {
                    GeometryReader{ geometry in
                        let size = geometry.size
                        WebImage(url: postImageURL)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size.width, height: size.height)
                            .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                    }
                    .frame(height: 200)
                }
                
                InternalPostInteraction()
            }
        }
        .horizontalAlign(.leading)
        .overlay(alignment: .topTrailing, content: {
            //delete button for OP
            if post.userUID == UserDefaults.standard.string(forKey: "user_id")! /*should create helper function to standardise this*/ {
                Menu {
                    Button(role: .destructive) {
                        deletePost()
                    } label: {
                        Text("Delete This Post")
                    }

                } label: {
                    Image(systemName: "ellipsis")
                        .font(.caption)
                        .rotationEffect(.init(degrees: -90))
                        .foregroundColor(.white)
                        .padding(.medium)
                        .contentShape(Rectangle())
                }
                .offset(x: .medium)
            }
        })
        .onAppear {
            //MARK: docListener is added only when post is visible onscreen
            //MARK: LazyVStack is designed to emit notifications if a child enters or exits screen visibility through onAppear & onDisappear methods respectively
            ///adding only once
            if docListener == nil {
                guard let postID = post.id else {
                    showErrorAlertView("Error", "Post ID not saved and initialised properly", handler: {})
                    return
                }
                docListener = Firestore.firestore().collection("Posts").document(postID).addSnapshotListener({ snapshot, error in
                    if let snapshot {
                        if snapshot.exists {
                            /// - Document updated
                            /// fetching updated document
                            if let updatedPost = try? snapshot.data(as: Post.self) {
                                onUpdate(updatedPost)
                            }
                        } else {
                           /// - Document deleted
                            onDelete()
                        }
                    }
                })
            }
        }
        .onDisappear {
            //MARK: Ensuring that live updates only occur for documents visible on screen to lower I/O cost of Firebase reads
            //MARK: DocumentListener is removed in such instances
            if let docListener {
                docListener.remove()
                self.docListener = nil
            }
        }
    }
    
    //MARK: upvote/downvote
    @ViewBuilder func InternalPostInteraction() -> some View {
        HStack(spacing: .small) {
            Button {
                upvote()
            } label: {
                Image(systemName: post.upvoteIDs.contains(UserDefaults.standard.string(forKey: "user_id")!) ? "hand.thumbsup.fill": "hand.thumbsup")
            }
            
            Text("\(post.upvoteIDs.count)")
                .font(.caption)
                .foregroundColor(.green)

            Button {
                downVote()
            } label: {
                Image(systemName: post.downvoteIDs.contains(UserDefaults.standard.string(forKey: "user_id")!) ? "hand.thumbsdown.fill" : "hand.thumbsdown")
            }
            .padding(.leading, .xLarge)
            
            Text("\(post.downvoteIDs.count)")
                .font(.caption)
                .foregroundColor(.red)
        }
        .foregroundColor(.white)
        .padding(.vertical, .medium)
    }
    
    //should find a way to use this while following MVVM
    //make these guard conditions at global scope so that these views will not used if the guard fails
    //should changed to upvote
    func upvote() {
        Task {
            //functionality to allow removing an upvote from a post if it had previously been upvoted
            guard let postID = post.id else {
                showErrorAlertView("Error", "Internal-Post ID not saved and initialised properly", handler: {})
                return
            }
            guard let userUID = UserDefaults.standard.string(forKey: "user_id") else {
                showErrorAlertView("Error", "User ID not found", handler: {})
                return
            }
            if post.upvoteIDs.contains(userUID) {
                try await Firestore.firestore().collection("Posts").document(postID).updateData([
                    "upvoteIDs" : FieldValue.arrayRemove([userUID])
                ])
            } else {
                //Adding userUID to upvote array and removing from downvote, if user had made a prior downvote
                try await Firestore.firestore().collection("Posts").document(postID).updateData([// may have structured my db differently from tut here
                    "upvoteIDs" : FieldValue.arrayUnion([userUID]),
                    "downvoteIDs" : FieldValue.arrayRemove([userUID])
                ])
            }
        }
    }
    
    func downVote() {
        Task {
            //functionality to allow removing an upvote from a post if it had previously been upvoted
            guard let postID = post.id else {
                showErrorAlertView("Error", "Post ID not saved and initialised properly", handler: {})
                return
            }
            guard let userUID = UserDefaults.standard.string(forKey: "user_id") else {
                showErrorAlertView("Error", "User ID not found", handler: {})
                return
            }
            do {
                if post.downvoteIDs.contains(userUID) {
                    try await Firestore.firestore().collection("Posts").document(postID).updateData([
                        "downvoteIDs" : FieldValue.arrayRemove([userUID])
                    ])
                } else {
                    //Adding userUID to downvote array and removing from upvote, if user had made a prior upvote
                    try await Firestore.firestore().collection("Posts").document(postID).updateData([// may have structured my db differently from tut here
                        "upvoteIDs" : FieldValue.arrayRemove([userUID]),
                        "downvoteIDs" : FieldValue.arrayUnion([userUID])
                    ])
                }
            } catch {
                await setError(error)
            }
        }
    }

    func deletePost() {
        Task {
            //step 1 - delete image from firebase storage
            do {
                guard let userUID = UserDefaults.standard.string(forKey: "user_id") else {
                    showErrorAlertView("Error", "Login Initialisation Error", handler: {})
                    return
                }
                if post.imageReferenceID != "" {
                    try await Storage.storage().reference().child(userUID).child("Social_Images").child(post.imageReferenceID).delete()
                }
                //Step 2 - delete firestore document
                guard let postID = post.id else {
                    showErrorAlertView("Error", "Something went wrong with initalising this missive", handler: {})
                    return
                }
                try await Firestore.firestore().collection("Posts").document(postID).delete()
            } catch {
                await setError(error)
            }
        }
    }
}
