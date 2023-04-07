//
//  Test.swift
//  Duke
//
//  Created by user226714 on 4/4/23.
//

import SwiftUI
import CoreLocationUI

struct Test: View {
    var body: some View {
        LocationButton(.shareMyCurrentLocation, action: {
                    
        })
        .symbolVariant(.fill)
        .font(.system(size: .large))
        .foregroundColor(.white)
        .tint(.purple.opacity(0.9))
        .cornerRadius(.medium)
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
