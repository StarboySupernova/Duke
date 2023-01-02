//
//  PostViewModel.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/2/23.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift

class PostViewModel: ObservableObject {
    ///  Post properties
    @Published var postText: String = ""
    @Published var postImageData: Data?
        
    func createPost(_ onPost: @escaping (Post) -> ()) {
        Task {
            do {
                guard let profileID = UserDefaults.standard.string(forKey: "user_id") else {
                    showErrorAlertView("Error", "Internal user login status error", handler: {})
                    return
                }
                guard let userName = UserDefaults.standard.string(forKey: "user_name") else {
                    showErrorAlertView("Error", "User not initialized", handler: {})
                    return
                }
                //uploading image, if any
                let imageReferenceID = "\(profileID)\(Date())"
                let storageRef = Storage.storage().reference().child(profileID).child("Social_Images").child(imageReferenceID)
                if let postImageData {
                    let _ = try await storageRef.putDataAsync(postImageData)
                    let downloadURL = try await storageRef.downloadURL()
                    
                    //creating post image
                    let post = Post(text: postText, imageURL: downloadURL, imageReferenceID: imageReferenceID, userName: userName , userUID: profileID)
                    try await createDocumentInFirebase(post, onPost)
                } else {
                    //Save plain post with no image provided
                    let post = Post(text: postText, userName: userName, userUID: profileID)
                    try await createDocumentInFirebase(post, onPost)
                }
            } catch {
                await setError(error)
            }
        }
    }
    
    func createDocumentInFirebase(_ post : Post, _ onPost: @escaping (Post) -> ()) async throws {
        //writing document to firebase firestore
        let doc = Firestore.firestore().collection("Internal_Posts").document()
        let _ = try doc.setData(from: post, completion: { error in
            if error == nil {
                var updatedPost = post
                updatedPost.id = doc.documentID
                onPost(updatedPost)
                showSuccessAlertView("✔️", "Success", handler: {})
            }
        })
    }
}
