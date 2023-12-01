//
//  CertificateItem.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 11/7/23.
//

import SwiftUI

struct CertificateItem: View {
    var item: Course
    var color1: Color = Color(red: 0.992, green: 0.247, blue: 0.2)
    var color2: Color = Color(red: 0.298, green: 0, blue: 0.784)

    @Binding var show: Bool

    #if os(iOS)
    var cornerRadius: CGFloat = 25
    #else
    var cornerRadius: CGFloat = 10
    #endif

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.system(size: 17, weight: .bold))
                        .bold()
                        .foregroundColor(.white)
                        .animation(nil)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Certificate")
                        .font(.footnote)
                        .foregroundColor(.white)
                        .opacity(0.8)
                }
                Spacer()
                Image(systemName: "info.circle")
                    .foregroundColor(.white)
                    .frame(width: 32, height: 32)
                    .background(Color.white.opacity(0.2))
                    .mask(Circle())
                    .shadow(radius: 30)
                    .onTapGesture {
                        show.toggle()
                    }
            }
            Spacer()
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Rectangle()
                        .frame(width: CGFloat.random(in: 20...60), height: 4)
                        .cornerRadius(2)
                        .foregroundColor(.white)
                        .opacity(0.4)
                    Rectangle()
                        .frame(width: CGFloat.random(in: 20...60), height: 4)
                        .cornerRadius(2)
                        .foregroundColor(.white)
                        .opacity(0.4)
                    Rectangle()
                        .frame(width: CGFloat.random(in: 20...60), height: 4)
                        .cornerRadius(2)
                        .foregroundColor(.white)
                        .opacity(0.4)
                }
                Spacer()
                VStack(alignment: .leading, spacing: 8) {
                    Rectangle()
                        .frame(width: CGFloat.random(in: 20...60), height: 4)
                        .cornerRadius(2)
                        .foregroundColor(.white)
                        .opacity(0.4)
                    Rectangle()
                        .frame(width: CGFloat.random(in: 20...60), height: 4)
                        .cornerRadius(2)
                        .foregroundColor(.white)
                        .opacity(0.4)
                    Rectangle()
                        .frame(width: CGFloat.random(in: 20...60), height: 4)
                        .cornerRadius(2)
                        .foregroundColor(.white)
                        .opacity(0.4)
                }
            }
            Rectangle()
                .frame(width: CGFloat.random(in: 60...140), height: 8)
                .cornerRadius(4)
                .foregroundColor(.white)
                .opacity(0.5)
        }
        .padding(16)
        .background(
            ZStack {
                RadialGradient(gradient: Gradient(colors: [color1, color2]), center: .topLeading, startRadius: 5, endRadius: 500)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .shadow(color: color2.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}


struct CertificateItem_Previews: PreviewProvider {
    static var previews: some View {
        CertificateItem(item: courses.first!, show: .constant(false))
    }
}
