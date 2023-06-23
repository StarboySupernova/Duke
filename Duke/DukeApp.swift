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

    init() {
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).backgroundColor = .black
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = .black
        UISearchBar.appearance().overrideUserInterfaceStyle = .dark
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                //.modifier(DarkModeViewModifier())
                .environmentObject(HomeViewModel())
            //using environmentobject for now because we do not have a clear view tree for preferenceview yet, so it is unclear where to set the stateobject, which is the preferred method of initialization
                .environmentObject(UserPreference(headerText: ["Cultural Preferences", "Vegetarian Preferences", "Seating Preferences", "Authentic Cuisine Preferences"], buttonText: ["Halaal", "Haram", "Pork", "Vegan", "Vegetarian", "Containing-Lactose", "Outdoor seating", "Recommend Wine Farms?","Wine-Tasting"], imageName: ["person.and.background.dotted","leaf.circle.fill", "wineglass", "fork.knife"])) //DEFAULT VALUES
            
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
