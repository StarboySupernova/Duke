//
//  PhotoPicker.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 1/2/23.
//

import SwiftUI

struct PhotoPicker: UIViewControllerRepresentable {
    //@Binding var show: Bool
    //@EnvironmentObject var registerVM: RegisterViewModel //no longer uploading images to Firebase
    //@Binding var imageData: Data?
    @Binding var avatar: UIImage?
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        //not needed in our case
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(photoPicker: self)
    }

    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        //UIImagePickerControllerDelegate is what fires off when user selects an image
        //UINavigationControllerDelegate necessary so we get access to a dismiss button
        
        let photoPicker: PhotoPicker
        
        init(photoPicker: PhotoPicker) {
            self.photoPicker = photoPicker
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.editedImage] as? UIImage {
                guard let data = image.jpegData(compressionQuality: 0.2), let compressedImage = UIImage(data: data) else {
                    showErrorAlertView("Error", "Image Picker Controller compression error", handler: {})
                    return
                }
                photoPicker.avatar = compressedImage
                //photoPicker.imageData = data
                //photoPicker.registerVM.image = data
                UserDefaults.standard.set(data, forKey: "user_Image")
            } else {
                showErrorAlertView("Error", "Unable to initialize info.editedImage into a usable data stream", handler: {})
            }
            picker.dismiss(animated: true)
        }
    }
}
