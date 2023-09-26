//
//  ExtensionOnAVCaptureSession.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 9/23/23.
//

import Foundation
import AVFoundation

extension AVCaptureSession {
    var movieFileOutput: AVCaptureMovieFileOutput? {
        let output = self.outputs.first as? AVCaptureMovieFileOutput
        
        return output
    }
    
    func addMovieInput() throws -> Self {
        // Add video input
        guard let videoDevice = AVCaptureDevice.default(for: AVMediaType.video) else { //default method to bring in a video device
            throw VideoError.device(reason: .unableToSetInput)
        }
        
        let videoInput = try AVCaptureDeviceInput(device: videoDevice) //connecting video device
        guard self.canAddInput(videoInput) else {
            throw VideoError.device(reason: .unableToSetInput)
        }
        
        self.addInput(videoInput)
        
        return self
    }
    
    func addMovieFileOutput() throws -> Self {
        guard self.movieFileOutput == nil else {
            // return itself if output is already set
            return self
        }
        /*
         Create AVCaptureMovieFileOutput and if it can be connected, call canAddOutput to connect it. Note that AVCaptureMovieFileOutput is created directly as an instance, unlike the input case.
         */
        let fileOutput = AVCaptureMovieFileOutput()
        guard self.canAddOutput(fileOutput) else {
            throw VideoError.device(reason: .unableToSetOutput)
        }
        
        self.addOutput(fileOutput)
        
        return self
    }
    
}

