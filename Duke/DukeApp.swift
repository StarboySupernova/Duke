//
//  DukeApp.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 12/2/22.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage

@main
struct DukeApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var straddleScreen: StraddleScreen =  StraddleScreen() //will be used as nevironment variable to control the postioning of VerticalTabBar

    init() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .black
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        UISearchBar.appearance().overrideUserInterfaceStyle = .dark
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                //.modifier(DarkModeViewModifier())
                .environmentObject(HomeViewModel())
                .environmentObject(straddleScreen)
        }
    }
}

//MARK: Used more verbose Firebase setup to enable OTP phone authentication in future
class AppDelegate: NSObject, UIApplicationDelegate {
    static var orientationLock = UIInterfaceOrientationMask.all //By default we want all our views to rotate freely
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //needed for phone Auth
    }
        
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        return AppDelegate.orientationLock
    }
}
