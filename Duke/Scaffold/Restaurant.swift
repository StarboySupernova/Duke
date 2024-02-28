//
//  Restaurant.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 11/23/23.
//

import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift
import SwiftUI
import Resolver
import Combine
import MapKit

struct Restaurant: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var tagLine: String?
    var address: String
    var cuisine: String?
    var cuisineFromOptions: [Cuisine] //as in, choose all that apply
    //read this for location on map https://firebase.google.com/docs/firestore/solutions/geoqueries
    var locationOnMap: GeoPoint
    var menuItems: [StockItem]?
    @ServerTimestamp var createdTime: Timestamp? ///Using a server-side timestamp is important when working with data that originates from multiple clients, as the clocks on the clients are most likely not in sync with each other.
    var userId: String?

    //var menus to allow multipe menus in restaurant screen
}

struct Cuisine: Codable {
    var halaal: Bool = false
    var haram: Bool = false
    var pork: Bool = false
    var vegan: Bool = false
    var vegetarian: Bool = false
    var lactose: Bool = false
    var outdoor: Bool = false
    var wineTasting: Bool = false
    var wineFarms: Bool = false
    
    ///authentic experiences preferences - show that on the list when presentin the choise in UI
    var african: Bool = true
    var italian: Bool = true
    var greek: Bool = true
    var chinese: Bool = true
    var thai: Bool = true
}

extension Cuisine: Identifiable {
    var id: String { UUID().uuidString }
    
    func collectBoolProperties() -> [String] {
        var boolProperties: [String] = []
        
        Mirror(reflecting: self).children.forEach { child in
            if let propertyName = child.label,
               let _ = child.value as? Bool {
                boolProperties.append(propertyName)
            }
        }
        
        return boolProperties
    }
}

struct RestaurantListView: View {
  @ObservedObject var restaurantListVM = RestaurantListViewModel()
  @State var presentAddNewItem = false
  
  var body: some View {
    NavigationView {
      VStack(alignment: .leading) {
        List {
          ForEach (restaurantListVM.restaurantCellViewModels) { restaurantCellVM in
              RestaurantCell(restaurantCellVM: restaurantCellVM)
          }
          .onDelete { indexSet in
            self.restaurantListVM.removeRestaurants(atOffsets: indexSet)
          }
          if presentAddNewItem {
              RestaurantCell(restaurantCellVM: RestaurantCellViewModel.newRestaurant()) { result in
              if case .success(let restaurant) = result {
                self.restaurantListVM.addRestaurant(restaurant: restaurant)
                  self.presentAddNewItem = false
              }
//              self.presentAddNewItem.toggle()
            }
          }
        }
        Button(action: {
            self.presentAddNewItem.toggle()
        }) {
          HStack {
            Image(systemName: "plus.circle.fill")
              .resizable()
              .frame(width: 20, height: 20)
            Text("New")
          }
        }
        .padding()
        .accentColor(Color(UIColor.systemRed))
      }
      .navigationBarTitle("Restaurants") //sort list such that this can say yOur restaurants or just the default restaurants
    }
  }
}

struct RestaurantListView_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantListView()
        .preferredColorScheme(.dark)
    }
}                 
 
class BaseRestaurantRepository {   
  @Published var restaurants = [Restaurant]()
}

protocol RestaurantRepository where Self: BaseRestaurantRepository {
  func addRestaurant(_ restaurant: Restaurant)
  func removeRestaurant(_ restaurant: Restaurant)
  func updateRestaurant(_ restaurant: Restaurant)
}

class RestaurantListViewModel: ObservableObject {
  @Published var restaurantRepository: RestaurantRepository = Resolver.resolve()
  @Published var restaurantCellViewModels = [RestaurantCellViewModel]()
  
  private var cancellables = Set<AnyCancellable>()
  
  init() {
    restaurantRepository.$restaurants.map { restaurant in
      restaurant.map { restaurant in
          RestaurantCellViewModel(restaurant: restaurant)
      }
    }
    .assign(to: \.restaurantCellViewModels, on: self)
    .store(in: &cancellables)
  }
  
  func removeRestaurants(atOffsets indexSet: IndexSet) {
    // remove from repo
    let viewModels = indexSet.lazy.map { self.restaurantCellViewModels[$0] }
    viewModels.forEach { restaurantCellViewModel in
      restaurantRepository.removeRestaurant(restaurantCellViewModel.restaurant)
    }
  }
  
    func addRestaurant(restaurant: Restaurant) {
        restaurantRepository.addRestaurant(restaurant)
    }
}

class RestaurantCellViewModel: ObservableObject, Identifiable  {
  @Injected var restaurantRepository: RestaurantRepository
  
  @Published var restaurant: Restaurant
  
  var id: String = ""
  @Published var completionStateIconName = ""
  
  private var cancellables = Set<AnyCancellable>()
  
    #warning("Modify this to be called when user is entering restaurant details in the UI")
  static func newRestaurant() -> RestaurantCellViewModel {
      RestaurantCellViewModel(restaurant: Restaurant(name: "", address: "", cuisineFromOptions: [], locationOnMap: GeoPoint(latitude: 0.0, longitude: 0.0), menuItems: []))
  }
  
  init(restaurant: Restaurant) {
      self.restaurant = restaurant
      guard let loggedInUserID = Auth.auth().currentUser?.uid else {
          showErrorAlertView("Error", "An error occurred when attempting to access your credentials", handler: {})
          return
      }
    
    $restaurant
      .map { $0.userId == loggedInUserID ? "checkmark.circle.fill" : "circle" } //something to signify you own the Restaurant
      .assign(to: \.completionStateIconName, on: self)
      .store(in: &cancellables)

    $restaurant
      .compactMap { $0.id }
      .assign(to: \.id, on: self)
      .store(in: &cancellables)
    
    $restaurant
      .dropFirst()
      .debounce(for: 0.8, scheduler: RunLoop.main)
      .sink { restaurant in
        self.restaurantRepository.updateRestaurant(restaurant)
      }
      .store(in: &cancellables)
  }
  
}

#warning("model this like the already extant BusinessCell")
struct RestaurantCell: View {
    @ObservedObject var restaurantCellVM: RestaurantCellViewModel
    @State private var editingNameTextfield = false
    @State private var nameIconBounce = false
    @State private var name = ""
    @State private var editingAddressTextfield = false
    @State private var addressIconBounce = false
    @State private var twitter = ""
    @State private var editingSiteTextfield = false
    @State private var siteIconBounce = false
    @State private var site = ""
    @State private var editingBioTextfield = false
    @State private var bioIconBounce = false
    @State private var bio = ""
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showActionAlert = false
    @State private var alertTitle = "Settings Saved!"
    @State private var alertMessage = "Your changes have been saved"
    @State private var selectedCuisine = "Duke"
    
    var cuisines: [String] = Cuisine().collectBoolProperties()
    
    var onCommit: (Result<Restaurant, InputError>) -> Void = { _ in }
    
  var body: some View {
      VStack {
#warning("include a way to attach to Firebase image URL, and store the images on disk")
          GradientTextfield(editingTextfield: $editingNameTextfield, textfieldString: $restaurantCellVM.restaurant.name, iconBounce: $nameIconBounce, textfieldPlaceholder: "Name", textfieldIconString: "at") {
              if !self.restaurantCellVM.restaurant.name.isEmpty {
                  self.onCommit(.success(self.restaurantCellVM.restaurant))
              }
              else {
                  self.onCommit(.failure(.empty))
              }
          }
          .id(restaurantCellVM.id)
          .autocapitalization(.words)
          .disableAutocorrection(true)
          .textContentType(.organizationName)
          
          GradientTextfield(editingTextfield: $editingAddressTextfield, textfieldString: $restaurantCellVM.restaurant.address, iconBounce: $addressIconBounce, textfieldPlaceholder: "Address", textfieldIconString: "at") {
              if !self.restaurantCellVM.restaurant.address.isEmpty {
                  self.onCommit(.success(self.restaurantCellVM.restaurant))
              }
              else {
                  self.onCommit(.failure(.empty))
              }
          }
          .id(restaurantCellVM.id)
          .autocapitalization(.words)
          .disableAutocorrection(true)
          .textContentType(.organizationName)
          
          if #available(iOS 16.0, *) {
              GradientText(text: "Set Location")
                  .padding()
                  .contextMenu {
                      Button {
                          // Add this item to a list of favorites.
                      } label: {
                          Label("Add to Favorites", systemImage: "heart")
                      }
                      
                      Button {
                          //
                      } label: {
                          Label("Set Different Location", systemImage: "heart")
                      }
                  } preview: {
                      RestaurantMap()
                  }
          } else {
              // Fallback on earlier versions
              GradientText(text: "Set Location")
                  .padding()
                  .contextMenu {
                      Button {
                          //
                      } label: {
                          Label("Set to Current Location", systemImage: "heart")
                      }
                      
                      Button {
                          //
                      } label: {
                          Label("Set Different Location", systemImage: "heart")
                      }
                  }
          }
          
          Picker("Pick Cuisine Options", selection: $selectedCuisine) {
              ForEach(cuisines) { cuisine in
                  Text(cuisine)
              }
          }
          .pickerStyle(.wheel)
          .onChange(of: selectedCuisine) { newValue in
              restaurantCellVM.restaurant.cuisineFromOptions
          }
          
      }
  }
}//https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-a-picker-and-read-values-from-it

class FirestoreRestaurantRepository: BaseRestaurantRepository, RestaurantRepository, ObservableObject {
    ///https://www.swiftanytime.com/blog/contextmenu-in-swiftui
    #warning("Configure Sign In With Apple after enrolling in Apple Dev program again")
    var db = Firestore.firestore()
    
    @Injected var authenticationService: AuthenticationService
    var restaurantsPath: String = "RestaurantBackend"
    var userId: String = "unknown"
    
    private var cancellables = Set<AnyCancellable>()
    
    override init() {
        super.init()
                
        #warning("Add other user sign in options")
        authenticationService.$user
            .compactMap { user in
                user?.uid
            }
            .assign(to: \.userId, on: self)
            .store(in: &cancellables)
        
        // (re)load data if user changes
        authenticationService.$user
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { user in
                self.loadUserData()
            })
            .store(in: &cancellables)
    }
    
    #warning("This is a load your data method, should create load all data")
    private func loadUserData() {
        db.collection(restaurantsPath)
            .whereField("userId", isEqualTo: self.userId)
            .order(by: "createdTime")
            .addSnapshotListener { (querySnapshot, error) in
                if let querySnapshot = querySnapshot {
                    self.restaurants = querySnapshot.documents.compactMap { document -> Restaurant? in
                        try? document.data(as: Restaurant.self)
                    }
                }
            }
    }
    
    private func loadAllData() {
        db.collection(restaurantsPath)
            .getDocuments { snapshot, error in
                if error != nil {
                    showErrorAlertView("Error", error!.localizedDescription, handler: {return})
                } else if snapshot != nil {
                    self.restaurants = snapshot!.documents.compactMap { document -> Restaurant? in
                        try? document.data(as: Restaurant.self)
                    }
                }
            }
    }
    
    func addRestaurant(_ restaurant: Restaurant) {
        do {
            var userTask = restaurant
            userTask.userId = self.userId
            let _ = try db.collection(restaurantsPath).addDocument(from: userTask)
        }
        catch {
            fatalError("Unable to encode restaurant: \(error.localizedDescription).")
        }
    }
    
    func removeRestaurant(_ restaurant: Restaurant) { 
        if let taskID = restaurant.id {
            db.collection(restaurantsPath).document(taskID).delete { (error) in
                if let error = error {
                    print("Unable to remove document: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func updateRestaurant(_ restaurant: Restaurant) {
        if let taskID = restaurant.id {
            do {
                try db.collection(restaurantsPath).document(taskID).setData(from: restaurant)
            }
            catch {
                fatalError("Unable to encode restaurant: \(error.localizedDescription).")
            }
        }
    }
}

#warning("Xcode bug here causes the following to be emitted to console during runtime 'Modifying state during view update, this will cause undefined behavior'. https://stackoverflow.com/questions/71953853/swiftui-map-causes-modifying-state-during-view-update proposes a workaround using MapKitCamera API, which unfortunately is only iOS 17+. See also https://chat.openai.com/share/1f63a8b2-807a-4760-9be2-ec1298212016")
struct RestaurantMap: View {
    @State private var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: -26, longitude: 28), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
    @State private var locations = [RestaurantLocation]()
    
    var body: some View {
        //https://developer.apple.com/documentation/mapkit/mkmapviewdelegate/1452327-mapviewdidfailloadingmap
        ZStack {
            Map(coordinateRegion: $mapRegion, annotationItems: locations) { location in
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude))
            }
            .ignoresSafeArea()
            
            Circle()
                .fill(.blue)
                .opacity(0.3)
                .frame(width: 32, height: 32)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        let newLocation = RestaurantLocation(id: UUID(), name: "New location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
                        locations.append(newLocation)
                    } label: {
                        Image(systemName: "plus")
                    }
                    .padding()
                    .background(.black.opacity(0.75))
                    .foregroundColor(.white)
                    .font(.title)
                    .clipShape(Circle())
                    .padding(.trailing)
                }
            }
        }
    }
}

struct RestaurantMap_Previews: PreviewProvider {
    static var previews: some View {
        RestaurantMap()
//        .preferredColorScheme(.dark)
    }
}

struct RestaurantLocation: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var description: String
    let latitude: Double
    let longitude: Double
}

