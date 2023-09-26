//
//  AuthorizationChecker.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 9/23/23.
//

import Foundation
import AVFoundation

struct AuthorizationChecker {
    let session = AVCaptureSession()
    
    static func checkCaptureAuthorizationStatus() async -> Status {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            return .permitted
            
        case .notDetermined:
            let isPermissionGranted = await AVCaptureDevice.requestAccess(for: .video)
            if isPermissionGranted {
                return .permitted
            } else {
                fallthrough
            }
            
        case .denied:
            fallthrough
            
        case .restricted:
            fallthrough
            
        @unknown default:
            return .notPermitted
        }
    }
}

extension AuthorizationChecker {
    enum Status {
        case permitted
        case notPermitted
        /*
         There’re four basic status for the result of the request, but for convenience, we’ll simplify them into two cases, permitted and notPermitted.
         denied & restricted is also treated as a state where you can't use the camera. Therefore, it returns notPermitted.
         */
    }
}
