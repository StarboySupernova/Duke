//
//  FirebaseView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 11/18/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct FirebaseView: View {
    @StateObject var firebaseHomeViewModel = FirebaseHomeViewModel()
    
    var body: some View {
        ZStack {
            VStack(spacing: .medium){
                HStack(spacing: .large) {
                    ToggleButton(icon: "line.horizontal.3") {
                        
                    }
                    .foregroundColor(.pink)
                    
                    Text(firebaseHomeViewModel.userLocation == nil ? "Locating" : "Deliver To")
                        .foregroundColor(.black)
                    
                    Text(firebaseHomeViewModel.userAddress)
                        .font(.caption)
                        .fontWeight(.heavy)
                        .foregroundColor(.pink)
                    
                    Spacer(minLength: 0)
                }
                .padding([.horizontal, .top])
                
                Divider()
                    .background(Color.black)
                
                HStack(spacing: .large) {
                    TextField("Search", text: $firebaseHomeViewModel.search)
                    
                    if firebaseHomeViewModel.search != "" {
                        ToggleButton(icon: "magnifyingglass") {
                            
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, .medium)
                
                Divider()
                    .background(Color.black)
                
                if firebaseHomeViewModel.items.isEmpty {
                    Spacer()
                    ProgressView()
                    Spacer()
                } else {
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(spacing: .xLarge) {
                            ForEach(firebaseHomeViewModel.filteredItems) { item in
                                ZStack(alignment: Alignment(horizontal: .center, vertical: .top)) {
                                    ItemView(item: item)
                                    
                                    HStack {
                                        Text("Free Delivery")
                                            .foregroundColor(.white)
                                            .padding(.vertical, .medium)
                                            .padding(.horizontal)
                                            .background(Color.pink)
                                        
                                        Spacer(minLength: 0)
                                        
                                        ToggleButton(icon: item.isAddedToCart ? "checkmark" : "plus") {
                                            firebaseHomeViewModel.addToCart(item: item)
                                        }
                                    }
                                    .padding(.trailing, .medium)
                                    .padding(.top, .medium)
                                }
                                .frame(width: getRect().width - 30)
                            }
                        }
                        .padding(.top, .medium)
                    }
                }
                
            }
            .onAppear {
                //calling location delegate
                firebaseHomeViewModel.locationManager.delegate = firebaseHomeViewModel
            }
            .onChange(of: firebaseHomeViewModel.search) { newValue in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    //to avoid continuous search requests
                    if newValue == firebaseHomeViewModel.search && firebaseHomeViewModel.search != "" {
                        firebaseHomeViewModel.filterData()
                    }
                }
                
                if firebaseHomeViewModel.search == "" {
                    //reset all data
                    withAnimation(.linear) {
                        firebaseHomeViewModel.filteredItems = firebaseHomeViewModel.items
                    }
                }
            }
            
            if firebaseHomeViewModel.noLocation {
                Text("Location Denied")
                    .frame(width: getRect().width - 100, height: 120)
                    .background(Color.white)
                    .cornerRadius(10)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color.black.opacity(0.3).ignoresSafeArea())
            }
        }
    }
}

struct FirebaseView_Previews: PreviewProvider {
    static var previews: some View {
        FirebaseView()
    }
}

struct ItemView: View {
    var item: StockItem
    var body: some View {
        VStack {
            WebImage(url: URL(string: item.uploadedImage ?? "https://placehold.co/600x400/pink/white?text=Duke"))
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: getRect().width - 30, height: 250)

            HStack(spacing: .medium){
                Text(item.name)
                
                Spacer(minLength: 0)
                
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: "star.fill")
                        .foregroundColor(index <= Int(item.userRating) ?? 0 ? .pink : .gray)
                }
            }
            
            HStack {
                Text(item.details)
                
                Spacer(minLength: 0)
            }
        }
    }
}

struct CartView: View {
    @ObservedObject var firebaseData: FirebaseHomeViewModel
    @Environment(\.presentationMode) var present
    var body: some View {
        VStack{
            HStack(spacing: 20) {
                ToggleButton(icon: "chevron.left") {
                    present.wrappedValue.dismiss()
                }
                
                Text("My Cart")
                    .font(.title)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .padding()
            //https://medium.com/swiftui-made-easy/context-menu-with-preview-in-swiftui-242eab7b9375
            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(firebaseData.cartItems){ cartItem in
                        HStack(spacing: .large){
                            WebImage(url: URL(string: cartItem.item.uploadedImage ?? "https://placehold.co/600x400/pink/white?text=Duke"))
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 130, height: 130)
                                .cornerRadius(15)
                            
                            VStack(alignment: .leading, spacing: .medium) {
                                Text(cartItem.item.name)
                                
                                Text(cartItem.item.details)
                                
                                HStack(spacing: .large) {
                                    Text("\(firebaseData.getPrice(value: cartItem.item.displayPrice))")

                                    Spacer(minLength: 0)
                                    
                                    ToggleButton(icon: "plus") {
                                        firebaseData.cartItems[firebaseData.getIndex(item: cartItem.item, isCartIndex: true)].quantity += 1
                                    }
                                    
                                    Text("\(cartItem.quantity)") 
                                    
                                    ToggleButton(icon: "minus") {
                                        if cartItem.quantity > 1 {
                                            firebaseData.cartItems[firebaseData.getIndex(item: cartItem.item, isCartIndex: true)].quantity -= 1
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        .contextMenu {
                            ToggleButton(icon: "trash") {
                                let index = firebaseData.getIndex(item: cartItem.item, isCartIndex: true)
                                let itemIndex = firebaseData.getIndex(item: cartItem.item, isCartIndex: false)
                                
                                firebaseData.items[itemIndex].isAddedToCart = false
                                firebaseData.filteredItems[itemIndex].isAddedToCart = false
                                
                                firebaseData.cartItems.remove(at: index)
                            }
                        }
                    }
                }
            }
        }
        .background(Color.gray.ignoresSafeArea())
    }
    
    func getIndex(item: StockItem) -> Int {
        return firebaseData.items.firstIndex { item1 in
            return item.id == item1.id
        } ?? 0
    }
}


