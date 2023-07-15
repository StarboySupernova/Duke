//
//  PingCheckerView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 7/13/23.
//

import SwiftUI

struct PingCheckerView: View {
    @State private var pingResponse: String = ""
    
    
    let pfData: [String: String] = [
        "merchant_id": "22307768",
        "merchant_key": "6p4d8gqkymobf",
        "return_url": "https://www.example.com",
        "notify_url": "https://www.example.com/notify_url",
        "m_payment_id": "UniqueId",
        "amount": "200",
        "item_name": "test product"
    ]
    let passPhrase = "/F/canmak3y0ul0v3m3aga/n"

    
    var body: some View {
        VStack {
            Text("Ping Response:")
                .font(.headline)
            
            Text(pingResponse)
                .font(.subheadline)
            
            Button("Check Ping") {
                sendPingRequest()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
    
    func sendPingRequest() {
        let url = URL(string: "https://api.payfast.co.za/ping")!
        
        // Set header parameters
        var headers = [
            "merchant-id": "6p4d8gqkymobf",
            "version": "v1",
            "timestamp": getCurrentTimestamp(),
            "signature": generateApiSignature(dataArray: pfData, passPhrase: passPhrase)
        ]
        
        // Create request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        // Send request
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            if let data = data {
                if let pingResponse = String(data: data, encoding: .utf8) {
                    DispatchQueue.main.async {
                        self.pingResponse = pingResponse
                    }
                }
            }
        }.resume()
    }
    
    func getCurrentTimestamp() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        let timestamp = formatter.string(from: Date())
        return timestamp
    }
    
    func generateSignature() -> String {
        // Implement your signature generation logic here
        // Include the necessary header and body variables in the signature generation process
        // Convert the resulting signature to lowercase and return it
        return ""
    }
}

struct PingCheckerView_Previews: PreviewProvider {
    static var previews: some View {
        PingCheckerView()
    }
}

