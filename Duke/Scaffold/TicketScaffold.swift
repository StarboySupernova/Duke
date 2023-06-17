//
//  TicketScaffold.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 5/13/23.
//

import Foundation
import SwiftUI

/*
 struct Tickets: View {
    @State var tickets: [TicketModel] = [
        TicketModel(image: "thor", title: "Thor", subtitle: "Love and Thunder", top: "thor-top", bottom: "thor-bottom"),
        TicketModel(image: "panther", title: "Black Panther", subtitle: "Wakanda Forever", top: "panther-top", bottom: "panther-bottom"),
        TicketModel(image: "scarlet", title: "Doctor Strange", subtitle: "in the Multiverse of Madness", top: "scarlet-top", bottom: "scarlet-bottom")
    ]
    
    var body: some View {
        ZStack {
            ForEach(tickets) { ticket in
                InfiniteStackView(tickets: $tickets, ticket: ticket)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}

struct InfiniteStackView: View {
    @Binding var tickets: UserPreference //replaced by preference store
    
    @GestureState var isDragging: Bool = false
    @State var offset: CGFloat = .zero
    @State var height: CGFloat = 0
    
    var body: some View {
        VStack {
            Ticket(title: ticket.title, subtitle: ticket.subtitle, top: ticket.top, bottom: ticket.bottom, height: $height)
        }
        .zIndex(getIndex() == 0 && offset > 100 ? Double(CGFloat(tickets.count) - getIndex()) - 1 : Double(CGFloat(tickets.count) - getIndex())) 
        .rotationEffect(.init(degrees: getRotation(angle: 10)))
        .rotationEffect(getIndex() == 1 ? .degrees(-6) : .degrees(0))
        .rotationEffect(getIndex() == 2 ? .degrees(6) : .degrees(0))
        .scaleEffect(getIndex() == 0 ? 1 : 0.9) //should make views disabled if they are not in foreground
        .offset(x: getIndex() == 1 ? -40 : 0)
        .offset(x: getIndex() == 2 ? 40 : 0)
        .offset(x: offset) //monitor offset to bring the view on/off screen
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gesture (
            DragGesture()
                .updating($isDragging, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    var translation = value.translation.width
                    translation = tickets.first?.id == ticket.id ? translation : 0
                    translation = isDragging ? translation : 0
                    
                    withAnimation(.easeInOut(duration: 0.3)) {
                        offset = translation
                        height = -offset / 5
                    }
                })
                .onEnded({ value in
                    let width = UIScreen.main.bounds.width
                    let swipedLeft = -offset > (width / 2)
                    let swipedRight = offset > (width / 2)
                    
                    withAnimation(.easeInOut(duration: 0.5)) {
                        if swipedLeft {
                            offset = -width
                            removeTicket()
                        } else {
                            if swipedRight {
                                offset = width
                                removeAndAdd()
                            } else {
                                offset = .zero
                                height = .zero
                            }
                        }
                    }
                })
        )
    }
    
    func removeAndAdd() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            var updatedTicket = ticket
            updatedTicket.id = UUID().uuidString
            
            tickets.append(updatedTicket)
            
            withAnimation(.spring()) {
                tickets.removeFirst()
            }
        }
    }
    
    func removeTicket() {
        withAnimation(.spring()) {
            tickets.removeFirst()
        }
    }
    
    func getRotation(angle: Double) -> Double {
        let width = UIScreen.main.bounds.width - 50
        let progress = offset / width
        
        return Double(progress * angle)
    }
    
    
}
 */

/*
 PreferenceView -> ContentView
 Tickets -> ??
 InfiniteStackView -> ParallaxView
 chatgpt - explain the usage of getIndex & removeAndAdd methods in InfiniteStackView
 
 */

