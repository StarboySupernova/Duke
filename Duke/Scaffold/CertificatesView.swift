//
//  CertificatesView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 11/7/23.
//
import SwiftUI

struct CertificatesView: View {
    @State var show = false
    @State var businesses = placeholderBusinesses
    
    var content: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: show ? 200 : 700))], spacing: 16) {
            ForEach(businesses.indices, id: \.self) { index in
                let flipView = FlipView(
                    business1: businesses[index],
                    business2: businesses[placeholderBusinesses.count - index - 1],
                    color1: gradients[index].color1,
                    color2: gradients[index].color2
                )
                    .frame(height: 220)
                    .onTapGesture {
//                        businesses[index].show.toggle()
                    }
                
                switch index {
                case 0:
                    flipView
                        .zIndex(3)
                case 1:
                    flipView
                        .offset(x: 0, y: show ? 50 : -200)
                        .scaleEffect(show ? 1 : 0.9)
                        .opacity(show ? 1 : 0.3)
                        .zIndex(2)
                case 2:
                    flipView
                        .offset(x: 0, y: show ? 100 : -450)
                        .scaleEffect(show ? 1 : 0.8)
                        .opacity(show ? 1 : 0.3)
                        .zIndex(1)
                default:
                    flipView
                        .offset(x: 0, y: show ? 150 : 0)
                        .scaleEffect(show ? 1 : 0.7)
                        .opacity(show ? 1 : 0)
                        .zIndex(0)
                }
            }
        }
        .animation(.easeInOut(duration: 0.8))
        .padding(.all, 16)
    }
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color("Background 2").edgesIgnoringSafeArea(.all)
            
            VStack {
                DateTitle(title: "Trending")
                    .foregroundColor(.offWhite)
                
                ScrollView {
                    content
                }
                .navigationBarHidden(true)
            }
            
            ToggleButton{
                show.toggle()
            }
            .padding()
        }
        
    }
}


struct CertificatesView_Previews: PreviewProvider {
    static var previews: some View {
        CertificatesView()
    }
}

struct DateTitle: View {
    var title = ""
    var location = ""
    var alignment: HorizontalAlignment = .leading
    
    let taskDateFormat: DateFormatter =     {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        return formatter
    }()
    
    var currentDate = Date()
    
    var body: some View {
        VStack(alignment: alignment, spacing: 0) {
            
            Text("\(currentDate, formatter: taskDateFormat)")
                .font(Font.subheadline.smallCaps()).bold()
            
            HStack {
                if alignment == .trailing {
                    Spacer()
                }
                Text(title)
                    .font(.largeTitle).bold()
                
                Text(location)
                    .font(.body)
                    .foregroundColor(.pink)
                
                if alignment == .leading {
                    Spacer()
                }
            }
        }
        .padding(.small)
        .offset(x: 0, y: 20)
    }
}


struct GradientModel: Identifiable {
    var id = UUID()
    var color1: Color
    var color2: Color
}

let gradients = [
    GradientModel(color1: Color(#colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)), color2: Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)), color2: Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)), color2: Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)), color2: Color(#colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 1, green: 0.2372547686, blue: 0.2905043662, alpha: 1)), color2: Color(#colorLiteral(red: 1, green: 0.3843648434, blue: 0.6932035685, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 0.2937400341, green: 0, blue: 0.8942368627, alpha: 1)), color2: Color(#colorLiteral(red: 0.5658400655, green: 0.415163815, blue: 0.9316975474, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 0, green: 0.4841632247, blue: 1, alpha: 1)), color2: Color(#colorLiteral(red: 0, green: 0.6239914894, blue: 1, alpha: 1))),
    GradientModel(color1: Color(#colorLiteral(red: 0, green: 0.736463666, blue: 1, alpha: 1)), color2: Color(#colorLiteral(red: 0.5029546022, green: 0.933009088, blue: 0.8488840461, alpha: 1)))
]

struct ToggleButton: View {
    var icon: String?
    var action: () -> ()
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: icon ?? "switch.2")
                .font(.system(size: 15, weight: .regular))
                .padding(.all, 8)
                .background(Color.black.opacity(0.6))
                .mask(Circle())
        }
    }
}


