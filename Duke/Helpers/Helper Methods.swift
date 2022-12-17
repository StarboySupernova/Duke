//
//  Helper Methods.swift
//  D.E.M.Trust
//
//  Created by Simbarashe Dombodzvuku on 10/31/22.
//

import Foundation
//import Firebase //importing Firebase implictly imports UIKit
import UIKit
import SwiftUI

func extract(_ stringKey: String) -> String? {
    let value = UserDefaults.standard.string(forKey: stringKey)
    return value
}

func showErrorAlertView (_ alertTitle: String, _ alertMessage: String, handler: @escaping () -> Void, failureHandler : (() -> Void)? = nil) {
    //should find a way to use failure handler in future
    //handler should handle when user opts to continue despite the error
    //failurehandler should handle when user wants to rectify error, like a retry calling function or going back to finish exam
    //right now this method only handles continue situations
    let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
    let ok = UIAlertAction(title: "Continue", style: .cancel) { _ in handler() }
    
    alertView.addAction(ok)
    
    //Presenting
    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    let window = windowScene?.windows.first
    let rootVC = window?.rootViewController
    rootVC?.present(alertView, animated: true)
}

func showSuccessAlertView (_ alertTitle: String, _ alertMessage: String, handler: @escaping () -> Void) {
    let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
    let ok = UIAlertAction(title: "OK", style: .default) { _ in handler() }
    
    alertView.addAction(ok)
    
    //Presenting
    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    let window = windowScene?.windows.first
    let rootVC = window?.rootViewController
    rootVC?.present(alertView, animated: true)
}

func showDecisionAlertView (_ alertTitle : String, _ alertMessage : String, cancelAction : @escaping () -> Void, continueAction : @escaping () -> Void) {
    let alertView = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
        cancelAction ()
    }
    
    let continnue = UIAlertAction(title: "Continue", style: .default) { _ in
        continueAction()
    }
    
    alertView.addAction(cancel)
    alertView.addAction(continnue)
    
    //Presenting
    let scenes = UIApplication.shared.connectedScenes
    let windowScene = scenes.first as? UIWindowScene
    let window = windowScene?.windows.first
    let rootVC = window?.rootViewController
    rootVC?.present(alertView, animated: true)
}

//restoring verification id when the app loads to we ensure that we still have a valid verification id if the app is terminated before the user completes the sign-in flow (for example, while switching to the SMS app
func restoreVerificationID () -> String? {
    let verificationID = UserDefaults.standard.string(forKey: "authVerificationID")
    return verificationID
}

