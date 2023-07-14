//
//  PingCheckerView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 7/13/23.
//

import SwiftUI

struct PingCheckerView: View {
    @State private var isPingSuccessful = false

    var body: some View {
        VStack {
            if isPingSuccessful {
                Text("Ping Successful!")
                    .font(.title)
                    .foregroundColor(.green)
            } else {
                Text("Ping Failed!")
                    .font(.title)
                    .foregroundColor(.red)
            }
            
            Button(action: {
                performPing()
            }) {
                Text("Check Ping")
                    .font(.title)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
    }
    
    private func performPing() {
        guard let url = URL(string: "https://api.payfast.co.za/ping") else {
            return
        }
        
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    if responseString == "OK" {
                        isPingSuccessful = true
                    } else {
                        isPingSuccessful = false
                    }
                } else {
                    isPingSuccessful = false
                }
            } else {
                isPingSuccessful = false
            }
        }.resume()
    }
}

struct PingCheckerView_Previews: PreviewProvider {
    static var previews: some View {
        PingCheckerView()
    }
}

