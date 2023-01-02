//
//  SearchUserView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/2/23.
//

import SwiftUI
import FirebaseFirestore

struct SearchUserView: View {
    @State private var fetchedUsers: [User] = []
    @State private var searchText: String = ""
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        List {
            ForEach(fetchedUsers) { user in
                NavigationLink {
                    //reduced redundancy here through the use of ReusableProfileContent
                    ReusableProfileContent(user: user)
                } label: {
                    Text(user.userName)
                        .font(.callout)
                        .horizontalAlign(.leading)
                }
            }
        }
        .listStyle(.plain)
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle("Search")
        .searchable(text: $searchText)
        .onSubmit(of: .search) {
            //Fetch user from Firebase
            Task {
                await searchUsers()
            }
        }
        .onChange(of: searchText, perform: { newValue in
            if newValue.isEmpty {
                fetchedUsers = []
            }
        })
        /*.toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                }
                .tint(.black)
            }
        }*/
    }
    
    /// asynchronous user search
    func searchUsers() async {
        do {
            /*let queryLowerCased = searchText.lowercased()
            let queryUpperCased = searchText.uppercased()*/
            
            //MARK: Limitations of using Firebase as a data store for a feature best suited to be stored in a relational db catch up with us here, there is need to look into other databases in future, or look into extending the capabilities of Firebase with tools and SDKs such as Algolia or Elastic
            //MARK: Because Firebase does not provide a String.contains features for String search, we have to use limited approach for string searches.
            //MARK: Used solution from SO https://stackoverflow.com/questions/46568142/google-firestore-query-on-substring-of-a-property-value-text-search
            let documents = try await Firestore.firestore().collection("Users").whereField("userName", isGreaterThanOrEqualTo: searchText) //try username instead of userName
                .whereField("userName", isLessThanOrEqualTo: "\(searchText)\u{f8ff}")
                .getDocuments()
            
            let users = try documents.documents.compactMap { doc -> User in
                try doc.data(as: User.self)
            }
            
            await MainActor.run(body: {
                fetchedUsers = users
            })
        } catch {
            showErrorAlertView("Error", error.localizedDescription, handler: {})
        }
    }
}

struct SearchUserView_Previews: PreviewProvider {
    static var previews: some View {
        SearchUserView()
    }
}
