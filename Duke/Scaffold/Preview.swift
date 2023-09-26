//
//  Preview.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 9/23/23.
//

import Foundation
import SwiftUI
import AVFoundation

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

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        previewLayer.videoGravity = gravity
        uiViewController.view.layer.addSublayer(previewLayer)
        
        previewLayer.frame = uiViewController.view.bounds
    }

    func dismantleUIViewController(_ uiViewController: UIViewController, coordinator: ()) {
        previewLayer.removeFromSuperlayer()
    }
}
