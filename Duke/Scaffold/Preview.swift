//
//  Preview.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 9/23/23.
//

import Foundation
import SwiftUI
import AVFoundation

// A SwiftUI View that represents a live camera preview using AVCaptureSession
struct Preview: UIViewControllerRepresentable {
    let previewLayer: AVCaptureVideoPreviewLayer
    let gravity: AVLayerVideoGravity

    init(
        with session: AVCaptureSession,
        gravity: AVLayerVideoGravity
    ) {
        self.gravity = gravity
        self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
    }

    // Create the UIViewController to host the AVCaptureVideoPreviewLayer
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        return viewController
    }

    // Update the UIViewController when the SwiftUI view changes
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        previewLayer.videoGravity = gravity
        // Add the AVCaptureVideoPreviewLayer as a sublayer to the UIViewController's view
        uiViewController.view.layer.addSublayer(previewLayer)
        
        // Ensure the preview layer fills the entire view
        previewLayer.frame = uiViewController.view.bounds
    }

    // Cleanup when the SwiftUI view is dismantled
    func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: ()) {
        // Remove the AVCaptureVideoPreviewLayer from its superlayer when no longer needed
        previewLayer.removeFromSuperlayer()
    }
}
