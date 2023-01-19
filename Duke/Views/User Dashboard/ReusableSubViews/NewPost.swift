//
//  NewPost.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/2/23.
//

import SwiftUI

struct NewPost: View {
    @EnvironmentObject var postVM : PostViewModel

    /// callback
    var onPost : (Post) -> ()
    
    @Environment(\.dismiss) var dismiss

    @State private var isLoading: Bool = false
    @State private var isShowingPhotoPicker: Bool = false
    @State private var avatar: UIImage? = nil
    @FocusState private var showKeyboard : Bool //to toggle keyboard onscreen
    var body: some View {
        VStack{
            HStack {
                Menu {
                    Button(role: .destructive) {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }
                } label: {
                    Text("Cancel")
                        .font(.callout)
                        .foregroundColor(.black)
                }
                .horizontalAlign(.leading)
                
                Button {
                    isLoading = true
                    showKeyboard = false
                    postVM.createPost(onPost)
                    isLoading = false
                    dismiss()
                } label: {
                    Text("Post")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding(.horizontal, .large)
                        .padding(.vertical, .medium)
                        .background(.pink, in: Capsule())
                }
                .disableWithOpacity(postVM.postText == "")
            }
            .padding(.horizontal, .large)
            .padding(.vertical, .medium)
            .background (
                Rectangle()
                    .fill(.gray.opacity(0.05))
                    .ignoresSafeArea()
            )
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    //MARK: iOS 16 code
                    /*if #available(iOS 16.0, *) {
                        TextField("What's New", text: $postVM.postText, axis: .vertical)
                            .focused($showKeyboard)
                            .padding(postVM.postText.isEmpty ? .xLarge : 0)
                            .paddedBorder(.white, 1)
                    } else {
                        // Fallback on earlier versions
                        List {
                            Text("What's New")
                            
                            ZStack {
                                TextEditor(text: $postVM.postText)
                                Text(postVM.postText)
                                    .opacity(0)
                                    .padding(.all, .medium)
                            }
                            .shadow(radius: 1)
                        }
                    }*/
                    List {
                        Text("What's New")
                        
                        ZStack {
                            TextEditor(text: $postVM.postText)
                            Text(postVM.postText)
                                .opacity(0)
                                .padding(.all, .medium)
                        }
                        .shadow(radius: 1)
                    }
                    
                    if let postImageData = postVM.postImageData, let image = UIImage(data: postImageData) {
                        GeometryReader{ geometry in
                            let size = geometry.size
                            Image(uiImage: image)
                                .resizedToFill(width: size.width, height: size.height)
                                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                                .overlay(alignment: .topTrailing) {
                                    //remove image button
                                    Button {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            postVM.postImageData = nil //iffy. may need binding for this
                                        }
                                    } label: {
                                        Image(systemName: "trash")
                                            .tint(.red)
                                    }
                                    .padding(.medium)
                                    //should add background here to make this more visible
                                }
                        }
                        .clipped()
                        .frame(height: 220)
                    }
                }
                .padding(.large)
            }
            
            Divider()
            
            HStack {
                Button {
                    isShowingPhotoPicker.toggle()
                } label: {
                    Image(systemName: "photo.on.rectangle")
                        .font(.title3)
                }
                .horizontalAlign(.leading)
                
                Button {
                    showKeyboard = false
                } label: {
                    Text("Hide Keyboard")
                }
            }
            .foregroundColor(.white)
            .padding(.horizontal, .large)
            .padding(.vertical, 10)
        }
        .verticalAlign(.top)
        .sheet(isPresented: $isShowingPhotoPicker) {
            isShowingPhotoPicker = false
        } content: {
            PhotoPicker(avatar: $avatar)
        }
        .onChange(of: avatar) { newValue in
            if newValue != nil { //may be iffy here, complier possibly cannot see the type of the object to change, i.e. avatar
                Task {
                    if let data = newValue!.jpegData(compressionQuality: 1.0) {
                        //UI must be updated on Main Thread
                        //iOS expects all UI changes to be on the main thread. SwiftUI is no exception
                        await MainActor.run(body: {
                            postVM.postImageData = data
                            avatar = nil
                        })
                    }
                }
            }
        }
        .overlay {
            LoadingView(show: $isLoading)
        }
    }
}

struct NewPost_Previews: PreviewProvider {
    static var previews: some View {
        NewPost { _ in
            
        }
        .environmentObject(PostViewModel())
        .preferredColorScheme(.dark)
    }
}
