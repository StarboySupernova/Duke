//
//  UserDataManagerViewModel.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 8/16/23.
//

/// Creating a singular class for user data management to avoid having multiple environmentObjects at top-level
/// Merging UserViewModel, UserPreference and HomeViewModel
import Foundation
import Firebase
import Combine
import MapKit
import ExtensionKit

//class UserDataManagerViewModel: ObservableObject {
//    //MARK: From pre-existing UserViewModel class
//    //login credentials & properties
//    @Published var loginEmail: String = ""
//    @Published var loginPassword: String = ""
//    @Published var myProfile: User?
//    
//    //internal employee credentials
//    @Published var email: String = ""
//    @Published var password: String = ""
//    @Published var userName: String = ""
//    //internal employee details
//    @Published var userBio : String = ""
//    @Published var userBioLink: String = ""
//    
//    //sign-in status
//    @Published var sign_in_status: Bool = false
//    
//    func internalRegistration () {
//        Task {
//            do {
//                //Step 1- Creating Firebase account
//                try await Auth.auth().createUser(withEmail: email, password: password)
//                //Step -2 - Creating a User Firestore object
//                guard let userID = Auth.auth().currentUser?.uid else {
//                    showErrorAlertView("Error", "Unable to detect user key ID", handler: {}) //should determine global retry method to run in scenarios such as this
//                    return
//                }
//                let user = User(userName: userName, userBio: userBio, userBioLink: userBioLink, userUID: userID, userEmail: email)
//                //Step 3 - Saving user doc into Firestore db
//                let _ = try Firestore.firestore().collection("Users").document(userID).setData(from: user, completion: { [unowned self] error in
//                    if error == nil {
//                        UserDefaults.standard.set(user.userName, forKey: "user_name")
//                        UserDefaults.standard.set(userID, forKey: "user_id")
//                        UserDefaults.standard.set(true, forKey: "sign_in_status") //iffy, because Bool UserDefaults value returns nil for both no value and a false value. Should find more elegant solution here
//                        sign_in_status = true
//                        print("Save successful")
//                    }
//                })
//            } catch {
//                await setError(error)
//            }
//        }
//    }
//    
//    func internalLogin() {
//        Task {
//            do {
//                // With the help of Swift concurrency Auth can be done on a single line
//                try await Auth.auth().signIn(withEmail: loginEmail, password: loginPassword)
//                print("user found")
//                try await fetchUser()
//            } catch {
//                await setError(error)
//            }
//        }
//    }
//    
//    func fetchUser() async throws {
//        guard let userID = Auth.auth().currentUser?.uid else {
//            return
//        }
//        let user = try await Firestore.firestore().collection("Users").document(userID).getDocument(as: User.self)
//        //UI updates must occur on Main Thread
//        await MainActor.run(body: {
//            UserDefaults.standard.set(user.userName, forKey: "user_name")
//            UserDefaults.standard.set(userID, forKey: "user_id")
//            UserDefaults.standard.set(true, forKey: "sign_in_status") //iffy, because Bool UserDefaults value returns nil for both no value and a false value. Should find more elegant solution here
//            sign_in_status = true
//            myProfile = user
//        })
//        print("fetch success")
//    }
//    
//    func resetPassword() {
//        Task {
//            do {
//                // With the help of Swift concurrency Auth can be done on a single line
//                try await Auth.auth().sendPasswordReset(withEmail: loginEmail)
//                print("reset link sent")
//            } catch {
//                await setError(error)
//            }
//        }
//    }
//    
//    func internalUserLogout () {
//        do {
//            try Auth.auth().signOut()
//            UserDefaults.standard.set(false, forKey: "sign_in_status")
//            sign_in_status = false
//            //create helper method to check UserDefaults which I can control when it will be called
//            myProfile = nil
//        } catch {
//            showErrorAlertView("Error", error.localizedDescription, handler: {})
//        }
//    }
//    
//    func deleteInternalUser() {
//        Task {
//            do {
//                guard let userUID = Auth.auth().currentUser?.uid else {
//                    showErrorAlertView("Error", "User should be logged in before performing this operation", handler: {})
//                    return
//                }
//                //deleting Firestore User document
//                try await Firestore.firestore().collection("Users").document(userUID).delete()
//                //deleting auth account
//                try await Auth.auth().currentUser?.delete()
//                UserDefaults.standard.set(false, forKey: "sign_in_status")
//                showSuccessAlertView("Success", "Account deleted successfully", handler: { [unowned self] in
//                    myProfile = nil
//                    sign_in_status = false
//                })
//                print("delete success")
//            } catch {
//                await setError(error)
//            }
//        }
//    }
//    
//    func saveUserPreference(_ userPreferenceStoreInstance: UserPreference) {
//        let encoder = JSONEncoder()
//        if let encoded = try? encoder.encode(userPreferenceStoreInstance) {
//            let defaults = UserDefaults.standard
//            defaults.set(encoded, forKey: userPreferenceStoreInstance.id) //to enable us to target different data sets for each user on the phone. This is not forecasted to increase past the 512kb recommended limit for UserDefaults data
//        }
//    }
//    
//    func fetchUserPreferences(for id: String) -> UserPreference? { //ID is stored in Firebase so this method is fine to write in its current configuration
//        let decoder = JSONDecoder()
//        guard let savedPerson = UserDefaults.standard.object(forKey: id) as? Data else {
//            showErrorAlertView("Error", "No preferences data found for this user", handler: {})
//            return nil
//        }
//        guard let loadedPerson = try? decoder.decode(UserPreference.self, from: savedPerson) else {
//            showErrorAlertView("Error", "Preferences data unable to be loaded at this time", handler: {})
//            return nil
//        }
//        
//        return loadedPerson
//    }
//    
//    //MARK: FROM UserPreference
//    
//    //should use MVVM here
//    //this class should be the model, with instances of this broadcasting (publishing) user selected data
//    //view model will handle storage to UserDefaults
//    //use of Dictionary values looking likely, but this will be determined later
//    //some properties to be moved to UserPreferenceModel https://paulallies.medium.com/swiftui-mvvm-a1e7a18f4f03
//    var id: String = UUID().uuidString //should be set to same as authid from Firebase. Should probably ensure this checks different IDs in UseDefaults and return specific user data for each user
//    var halaal: Bool = false
//    var haram: Bool = false
//    var pork: Bool = false
//    var vegan: Bool = false
//    var vegetarian: Bool = false
//    var lactose: Bool = false
//    var outdoor: Bool = false
//    var wineTasting: Bool = false
//    var wineFarms: Bool = false
//    
//    ///authentic experiences preferences
//    var african: Bool = true
//    var italian: Bool = true
//    var greek: Bool = true
//    var chinese: Bool = true
//    var thai: Bool = true
//    
//    //Add attributed description texts
//    //View model will handle saving to keychain
//    
//    init(isHalaal: Bool = false, haram: Bool = false, pork: Bool = false, vegan: Bool = false,
//             vegetarian: Bool = false, lactose: Bool = false, outdoor: Bool = false,
//             wineTasting: Bool = false, wineFarms: Bool = false, african: Bool = true,
//             italian: Bool = true, greek: Bool = true, chinese: Bool = true, thai: Bool = true) {
//            
//            self.halaal = isHalaal
//            self.haram = haram
//            self.pork = pork
//            self.vegan = vegan
//            self.vegetarian = vegetarian
//            self.lactose = lactose
//            self.outdoor = outdoor
//            self.wineTasting = wineTasting
//            self.wineFarms = wineFarms
//            self.african = african
//            self.italian = italian
//            self.greek = greek
//            self.chinese = chinese
//            self.thai = thai
//        }
//    
//    static let shared = UserPreference()
//    
//    ///The private initializer private init() ensures that the UserPreference class cannot be instantiated from outside the class. It prevents accidental creation of multiple instances and enforces the use of the shared singleton instance.
//    private init() {
//        searchText = ""
//        selectedCategory = FoodCategory.all.rawValue
//        region = .init()
//        businessDetails = nil //initialized as nil until fetched from API
//        showModal = manager.authorizationStatus == .notDetermined
//        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters //using best accuracy location in computationally expensive and battery intensive
//        
//        request()
//    }
//    
//    private enum CodingKeys: String, CodingKey {
//        case id
//        case halaal
//        case haram
//        case pork
//        case vegan
//        case vegetarian
//        case lactose
//        case outdoor
//        case wineTasting
//        case wineFarms
//        case african
//        case italian
//        case greek
//        case chinese
//        case thai
//    }
//    
//    required init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(String.self, forKey: .id)
//        halaal = try container.decode(Bool.self, forKey: .halaal)
//        haram = try container.decode(Bool.self, forKey: .haram)
//        pork = try container.decode(Bool.self, forKey: .pork)
//        vegan = try container.decode(Bool.self, forKey: .vegan)
//        vegetarian = try container.decode(Bool.self, forKey: .vegetarian)
//        lactose = try container.decode(Bool.self, forKey: .lactose)
//        outdoor = try container.decode(Bool.self, forKey: .outdoor)
//        wineTasting = try container.decode(Bool.self, forKey: .wineTasting)
//        wineFarms = try container.decode(Bool.self, forKey: .wineFarms)
//        african = try container.decode(Bool.self, forKey: .african)
//        italian = try container.decode(Bool.self, forKey: .italian)
//        greek = try container.decode(Bool.self, forKey: .greek)
//        chinese = try container.decode(Bool.self, forKey: .chinese)
//        thai = try container.decode(Bool.self, forKey: .thai)
//    }
//        
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(id, forKey: .id)
//        try container.encode(halaal, forKey: .halaal)
//        try container.encode(haram, forKey: .haram)
//        try container.encode(pork, forKey: .pork)
//        try container.encode(vegan, forKey: .vegan)
//        try container.encode(vegetarian, forKey: .vegetarian)
//        try container.encode(lactose, forKey: .lactose)
//        try container.encode(outdoor, forKey: .outdoor)
//        try container.encode(wineTasting, forKey: .wineTasting)
//        try container.encode(wineFarms, forKey: .wineFarms)
//        try container.encode(african, forKey: .african)
//        try container.encode(italian, forKey: .italian)
//        try container.encode(greek, forKey: .greek)
//        try container.encode(chinese, forKey: .chinese)
//        try container.encode(thai, forKey: .thai)
//    }
//    
//    /*
//    ///subscript may not have been needed to be done in this way. Instead of creating our own Binding retunred from the subscript, we were supposed to pass in a UserPreference object as is to ParallaxView, then hook into the bindings provided by the StateObject on its @Published properties
//    ///-- Route taken in this case assumed StateObject values will change in-between ParallaxView swipes offscren, hence the need to create custom subscript returning custom bindings to our properties by string name
//    ///--However, this implmentation was needed such that ParaalxView can be able initialize it's buttons based on its buttonText array input and creating bindings to them on the fly
//    ///The unintended result of this approach is that we have to explictly initalize the StateObject, which has performance and functionality side-effects we may not anticipate
//    subscript(dynamicMember key: String) -> Binding<Bool> {
//        Binding<Bool>(
//            get: {
//                return self.value(for: key)
//            },
//            set: { newValue in
//                self.setValue(newValue, for: key)
//            }
//        )
//    }
//    
//    private func value(for key: String) -> Bool {
//        return Mirror(reflecting: self).children
//            .compactMap { $0 as? (label: String?, value: Bool) }
//            .first { $0.label == key }?.value ?? false
//    }
//    
//    private func setValue(_ newValue: Bool, for key: String) {
//        let mirror = Mirror(reflecting: self)
//        guard var target = mirror.children
//            .first(where: {
//                ($0.label ?? "") == key
//            })?.value as? Published<Bool> else {
//            return
//        }
//        
//        target = Published<Bool>(wrappedValue: newValue)
//    }
//     */
//    
//    @Published var businesses = [Business]()
//    @Published var searchText : String
//    @Published var selectedCategory: String
//    @Published var region : MKCoordinateRegion
//    @Published var businessDetails : BusinessDetails?
//    @Published var showModal : Bool
//    @Published var cityName : String = ""
//    @Published var completions = [String]()
//    
//    let manager = CLLocationManager()
//    
////    init() {
////        searchText = ""
////        selectedCategory = FoodCategory.all.rawValue
////        region = .init()
////        businessDetails = nil //initialized as nil until fetched from API
////        showModal = manager.authorizationStatus == .notDetermined
////        manager.desiredAccuracy = kCLLocationAccuracyHundredMeters //using best accuracy location in computationally expensive and battery intensive
////
////        request()
////    }
//    
//    //using methods from ExtensionKit to leverage Combine to provide AuthorizationStatus publisher and avoid implementing a delegate pattern
//    func requestPermission() {
//#warning("should change code in this method, it is causing issues when user selects Allow Once")
//        manager
//            .requestLocationAlwaysAuthorization()
//            .map {  [unowned self] in
//                isLocationAccessGranted($0)
//            } //if this is false, the modal sheet will dismiss
//            .assign(to: &$showModal)//show modal should be responsbile for showing error if location access is not given
//    }
//    
//    func isLocationAccessGranted(_ locationStatus: CLAuthorizationStatus) -> Bool {
//        if locationStatus == .notDetermined || locationStatus == .denied || locationStatus == .restricted {
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                showErrorAlertView("Location access not given", "This application cannot function properly without location access. Please enable location access inside Settings App", handler: {})
//            }
//            return false
//        } else {
//            return false
//        }
//    }
//    
//    func getLocation () -> AnyPublisher<CLLocation, Never> {
//        manager.receiveLocationUpdates(oneTime: true) //will run when app launches
//            .replaceError(with: [])
//            .compactMap(\.first)
//            .eraseToAnyPublisher()
//    }
//    
//    func request (service: YelpAPIService = .live) {
//        let location = getLocation().share()
//        
//        //combining search text notifications with notifications from the selected category & location
//        $searchText
//            .debounce(for: 0.4, scheduler: DispatchQueue.main)
//            .combineLatest($selectedCategory, location)
//        //transforming publishers (tuple) into a search request
//            .flatMap { (term, category, location) in
//                service.request(
//                    .search(
//                        searchTerm: term,
//                        location: location,
//                        category: (term.isEmpty || term.isBlank) ? category : nil)
//                )
//            }
//            .assign(to: &$businesses)
//        
//        location
//            .flatMap {
//                $0.reverseGeocode()
//            }
//            .compactMap(\.first)
//            .compactMap(\.locality)
//            .replaceError(with: "Loading...")
//            .assign(to: &$cityName)
//        
//        $searchText
//            .debounce(for: 0.4, scheduler: DispatchQueue.main)
//            .combineLatest(location)
//            .flatMap { term, location in
//                service.completion(.completion(text: term, location: location))
//            }
//            .map { $0.map(\.text) }
//            .assign(to: &$completions)
//    }
//    
//    func requestDetails(forID id : String) {
//        let live = YelpAPIService.live
//        
//        let details = live.detailRequest(.detail(id: id))
//            .share() //share output with multiple subscribers, i.e. business & region
//        
//        details
//            .compactMap { business in
//                CLLocationCoordinate2D(latitude: business?.coordinates?.latitude ?? 0, longitude: business?.coordinates?.longitude ?? 0)
//            }
//            .compactMap { coordinates in
//                MKCoordinateRegion(center: coordinates, span: .init(latitudeDelta: 0.001, longitudeDelta: 0.001))
//            }
//            .assign(to: &$region)
//        
//        details
//            .print()
//            .assign(to: &$businessDetails)
//    }
//    
//}

