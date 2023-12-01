//
//  FirebaseHomeViewModel.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 11/18/23.
//

import Foundation
import CoreLocation
import Firebase

class FirebaseHomeViewModel : NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var locationManager = CLLocationManager()
    @Published var search = ""
    
    //Location details
    @Published var userLocation: CLLocation!
    @Published var userAddress: String = ""
    @Published var noLocation:Bool = false
    
    //Item Data
    @Published var items: [StockItem] = []
    @Published var filteredItems: [StockItem] = []
    
    @Published var cartItems: [Cart] = []
    @Published var ordered: Bool = false
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        //checking location access...
        switch manager.authorizationStatus {
        case .authorizedWhenInUse :
            print("authorized")
            manager.requestLocation()
            self.noLocation = false
        case .denied:
            print("denied")
            self.noLocation = true
        default:
            print("unknown")
            self.noLocation = false
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("location didFailWIthError error")
        print(error.localizedDescription)
        showErrorAlertView("Error", error.localizedDescription, handler: { return })
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //reading user location and extracting details
        self.userLocation = locations.last
        self.extractLocation()
        self.anonymousLogin()
    }
    
    func extractLocation() {
        CLGeocoder().reverseGeocodeLocation(self.userLocation) { result, error in
            guard let safeData = result else { return }
            var address = ""
            
            //getting area and locality name
            address += safeData.first?.name ?? ""
            address += " ,"
            address += safeData.first?.locality ?? ""
            
            self.userAddress = address
        }
    }
    
    func anonymousLogin(){
        Auth.auth().signInAnonymously { (result , error) in
            if error != nil {
                print("anonymous user error")
                showErrorAlertView("Error", error!.localizedDescription, handler: {})
                return
            }
            print("Success = \(result!.user.uid)")
            #warning("add anonymous login option in Sign In view controller")
            showSuccessAlertView("✔️", "Logged in anonymously", handler: {})
            
//            self.fetchItemData()
        }
    }
    
    func fetchItemData(for restaurant: Restaurant) {
        let db = Firestore.firestore()
        
        db.collection("RestaurantBackend").getDocuments { snapshot, error in
            guard let itemData = snapshot else { return } //emit an error alert here
            
            self.items = itemData.documents.compactMap({ doc in
                let id = doc.documentID
                let name = doc.get("name") as! String
                let cost = doc.get("displayPrice") as! NSNumber
                let ratings = doc.get("userRatings") as! String
                let image = doc.get("uploadedImage") as! String
                let details = doc.get("details") as! String
                
                return StockItem(id: id, name: name, displayPrice: Float(cost), details: details, uploadedImage: image, userRating: ratings)
            })
            
            self.filteredItems = self.items
        }
    }
    
    func filterData() {
        self.filteredItems = self.items.filter({
            return $0.name.lowercased().contains(self.search.lowercased())
        })
    }
    
    func addToCart(item: StockItem) {
        self.items[getIndex(item: item, isCartIndex: false)].isAddedToCart = !item.isAddedToCart
        let filterIndex = self.filteredItems.firstIndex { item1 in
            return item.id == item1.id
        } ?? 0
        self.filteredItems[filterIndex].isAddedToCart = !item.isAddedToCart

        if item.isAddedToCart {
            self.cartItems.remove(at: getIndex(item: item, isCartIndex: true))
            return
        }
        
        self.cartItems.append(Cart(item: item, quantity: 1))
    }
    
    func getIndex(item: StockItem, isCartIndex: Bool) -> Int {
        let index = self.items.firstIndex { item1 in
            return item.id == item1.id
        } ?? 0
        
        let cartIndex = self.cartItems.firstIndex { item1 in
            return item.id == item1.item.id
        } ?? 0
        
        return isCartIndex ? cartIndex : index
    }
    
    func calculateTotalPrice() -> String {
        var price: Float = 0
        
        cartItems.forEach { cartItem in
            price += Float(cartItem.quantity) * cartItem.item.displayPrice
        }
        
        return getPrice(value: price)
    }
    
    func getPrice(value: Float) -> String {
        let format = NumberFormatter()
        format.numberStyle = .currency
        
        return format.string(from: NSNumber(value: value)) ?? ""
    }
    
    func createRestaurant(_ restaurant: Restaurant) {
        let db = Firestore.firestore()
        do {
            #warning("not a warning per se, but look into FirebaseEncoder & Decoder")
            let newRestaurantDocRef = try db.collection("RestaurantBackend").addDocument(from: restaurant) { _ in
                ///A block to execute once the document has been successfully written to the server. This block will not be called while the client is offline, though local changes will be visible immediately.
                showSuccessAlertView("✔️", "Success", handler: {})
            }
        } catch {
            showErrorAlertView("Error", error.localizedDescription, handler: {})
            return
        }
    }
    
#warning("modify this update code and also the fetch code such that you can only get access to the returned restaurant if your id was used to create the restaurant in the first place")

    func updateRestaurant(_ restaurant: Restaurant) {
        let db = Firestore.firestore()
        if let id = restaurant.id { //might be iffy, our id maybe auto generated
            let docRef = db.collection("RestaurantBackend").document(id)
                do {
                  try docRef.setData(from: restaurant)
                }
                catch {
                    showErrorAlertView("Error", error.localizedDescription, handler: {})
                    return
                }
        }
    }
    
    func fetchRestaurant(by name: String) {
        let db = Firestore.firestore()
        
        db.collection("RestaurantBackend").getDocuments { querySnapshot, error in
            guard error == nil else {
                showErrorAlertView("Error", error!.localizedDescription, handler: {})
                return
            }
            
            var restaurantArray: [Restaurant] = []
            for document in querySnapshot!.documents {
                do {
                    let decodedDocument = try document.data(as: Restaurant.self)
                    if decodedDocument.name != name {
                        continue
                    } else {
                        restaurantArray.append(decodedDocument)
                    }
                } catch {
                    showErrorAlertView("Error", error.localizedDescription, handler: {})
                    return
                }
            }
        }
    }
    //writing order data into Firestore
    func updateOrder() {
        let db = Firestore.firestore()
        if ordered {
            ordered = false
            db.collection("Users").document(Auth.auth().currentUser!.uid).delete { error in
                if error != nil {
                    showErrorAlertView("Error", error!.localizedDescription, handler: {})
                    return
                }
            }
            return
        }
        var details: [[String: Any]] = []
        
        cartItems.forEach { cartItem in
            details.append([
                "name": cartItem.item.name,
                "quantity": cartItem.quantity,
                "displayPrice": cartItem.item.displayPrice,
            ])
        }
        
        ordered = true
        db.collection("Users").document(Auth.auth().currentUser!.uid).setData([
            "ordered_food": details,
            "total_cost": calculateTotalPrice(),
            "location": GeoPoint(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        ]) {(error) in
            if error != nil {
                showErrorAlertView("Error", error!.localizedDescription) {
                    
                }
                self.ordered = false
                return
            }
            print("order update successful")
            //create Restaurant object with all the options from UserPreference, which the restaurants can choose from
        }
    }
}

struct StockItem: Identifiable, Codable {
    var id = UUID().uuidString
    var name: String
    var displayPrice: Float //replce NSNumber with Float elsewhere since I replaced it here
    var details: String
    var uploadedImage: String? //can allow someone to use a link to their socials if the product can be found there
    var userRating: String //should possibly be Int
    var cuisine: Cuisine?
    var isAddedToCart: Bool = false
}

struct Cart: Identifiable {
    var id = UUID().uuidString + formattedDate() + (Auth.auth().currentUser?.uid ?? "user id not properly initilaized at this time")
    var item: StockItem
    var quantity: Int
}




