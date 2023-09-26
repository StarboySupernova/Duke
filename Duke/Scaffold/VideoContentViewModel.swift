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
                try session
                    .addMovieInput()
                    .addMovieFileOutput()
                    .startRunning() //startRunning is a thread-blocking method that can impair responsiveness if run on the main thread. This is why the background priority is given to Task.
                
                DispatchQueue.main.async {
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
          
          let fileName = UUID().uuidString

          let filePath = directoryPath
              .appendingPathComponent(fileName)
              .appendingPathExtension("mp4")
          
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

  extension VideoContentViewModel: AVCaptureFileOutputRecordingDelegate {
      func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
          print("Video record is finished!")
          
          // ADDED
          Task {
              guard
                  case .authorized = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
              else {
                  print("Cannot gain authorization")
                  return
              }
              
              let library = PHPhotoLibrary.shared()
              let album = try getAlbum(name: "YOUR_ALBUM_NAME", in: library)
              try await add(video: outputFileURL, to: album, library)
          }
      }
  }

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
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", name)
        
        let collection = PHAssetCollection.fetchAssetCollections(
            with: .album, subtype: .any, options: fetchOptions
        )

        if let album = collection.firstObject {
            return album
        } else {
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



