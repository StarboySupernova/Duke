//
//  HouseView.swift
//  Duke
//
//  Created by user226714 on 8/4/23.
//

import SwiftUI
import RiveRuntime

//MARK: Useful for making reservations to specify how many diners

struct HouseView: View {
    let animation = RiveViewModel(fileName: "house", stateMachineName: "State Machine 1")
    @State var rooms: Float = 3
    
    var body: some View {
        VStack {
            Stepper(value: $rooms, in: 3...6) {
                Text(String(format: "%.0f", rooms))
            }
            .padding(20)

            animation.view()
        }
        .onChange(of: rooms) { newValue in
            changeValue()
        }
        .onAppear {
            changeValue()
        }
    }
    
    func changeValue() {
            
    }
}

struct HouseView_Previews: PreviewProvider {
    static var previews: some View {
        HouseView()
    }
}
