//
//  VideoContentViewModel.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 9/23/23.
//

import Foundation
import AVFoundation
import Photos

class VideoContentViewModel: NSObject, ObservableObject {
    let session: AVCaptureSession
    @Published var preview: Preview?
    
    override init() {
        self.session = AVCaptureSession()
        
        super.init()
        
        Task(priority: .background) {
            switch await AuthorizationChecker.checkCaptureAuthorizationStatus() {
            case .permitted:
                // Add video input and output, then start the session asynchronously.
                try session
                    .addMovieInput()
                    .addMovieFileOutput()
                    .startRunning() //startRunning is a thread-blocking method that can impair responsiveness if run on the main thread. This is why the background priority is given to Task.
                
                DispatchQueue.main.async { // Update the preview on the main thread.
                    self.preview = Preview(with: self.session, gravity: .resizeAspectFill)
                }
                
            case .notPermitted:
                break
            }
        }
    }
    
    func startRecording() {
          guard let output = session.movieFileOutput else {
              print("Cannot find movie file output")
              return
          }
          
          guard
              let directoryPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
          else {
              print("Cannot access local file domain")
              return
          }
        #warning("Generate a unique filename for the recorded video based on userID, not just at random such as the present implementation")
          let fileName = UUID().uuidString

          let filePath = directoryPath
              .appendingPathComponent(fileName)
              .appendingPathExtension("mp4")
          
        // Start recording to the specified file path.
          output.startRecording(to: filePath, recordingDelegate: self)
      }
      
      func stopRecording() {
          guard let output = session.movieFileOutput else {
              print("Cannot find movie file output")
              return
          }
          
          output.stopRecording()
      }
  }

// Adding conformance to AVCaptureFileOutputRecordingDelegate for recording callbacks.
  extension VideoContentViewModel: AVCaptureFileOutputRecordingDelegate {
      func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
          print("Video record is finished!")
          
          //Requesting authorization to save the video to the photo library.
          Task {
              guard
                  case .authorized = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
              else {
                  print("Cannot gain authorization")
                  return
              }
              
              #warning("Should come back and catch errors defined & emitted here")
              let library = PHPhotoLibrary.shared()
              let album = try getAlbum(name: "YOUR_ALBUM_NAME", in: library)
              try await add(video: outputFileURL, to: album, library)
          }
      }
  }

// Extension for helper functions related to saving to the photo library
extension VideoContentViewModel {
    /// Add the video to the app's album roll
    func add(video path: URL, to album: PHAssetCollection, _ photoLibrary: PHPhotoLibrary) async throws -> Void {
        return try await photoLibrary.performChanges {
            guard
                let assetChangeRequest = PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: path),
                let placeholder = assetChangeRequest.placeholderForCreatedAsset,
                let albumChangeRequest = PHAssetCollectionChangeRequest(for: album)
            else {
                print("Cannot access to album")
                return
            }
            
            let enumeration = NSArray(object: placeholder)
            albumChangeRequest.addAssets(enumeration)
        }
    }
    
    func getAlbum(name: String, in photoLibrary: PHPhotoLibrary) throws -> PHAssetCollection {
        // Create a new instance of PHFetchOptions, which is used to specify options for fetching assets or collections from the Photos library.
        let fetchOptions = PHFetchOptions()

        // Set a predicate for filtering the fetched results based on a condition.
        // In this case, we are creating an NSPredicate that filters based on the "title" property being equal to the provided "name".
        fetchOptions.predicate = NSPredicate(format: "title = %@", name)
        
        let collection = PHAssetCollection.fetchAssetCollections(
            with: .album, subtype: .any, options: fetchOptions
        )

        if let album = collection.firstObject {
            return album
        } else {
            #warning("should handle potential errors thrown here")
            // If the album doesn't exist, create it.
            try createAlbum(name: name, in: photoLibrary)
            return try getAlbum(name: name, in: photoLibrary)
        }
    }
    
    func createAlbum(name: String, in photoLibrary: PHPhotoLibrary) throws {
        try photoLibrary.performChangesAndWait {
            PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: name)
        }
    }
}



