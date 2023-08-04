//
//  Dashboard.swift
//  ResponsiveUI Project 2
//
//  Created by Simbarashe Dombodzvuku on 6/21/22.
//

//import SwiftUI
//
//struct Dashboard: View {
//    var prop: Properties
//    @Binding var showSideBar: Bool
//
//    var body: some View {
//        ScrollView(.vertical, showsIndicators: false) {
//            let showStorageDetails = prop.isiPad && !prop.isSplit && prop.isLandscape
//            VStack(spacing: 15) {
//                TopNavBar()
//
//                VStack(spacing: 15) {
//                    HStack {
//                        Text("My Files")
//                            .fontWeight(.semibold)
//                            .foregroundColor(.white)
//
//                        Spacer(minLength: 10)
//
//                        Button {
//
//                        } label: {
//                            Label {
//                                Text("Add New")
//                            } icon: {
//                                Image(systemName: "plus.fill")
//                            }
//                            .font(.callout.bold())
//                            .foregroundColor(.white)
//                            .padding(.vertical, 10)
//                            .padding(.horizontal, 20)
//                            .background {
//                                RoundedRectangle(cornerRadius:4, style: .continuous)
//                                    .fill(Color.blue)
//                            }
//                        }
//                    }
//                    .padding(.vertical)
//
//                    OnlineStorageView()
//
//                    //MARK: Recent Files View
//                    FilesView()
//                        .padding(.top)
//
//                    //MARK: Showing only for smaller screen sizes
//                    if !showStorageDetails {
//                        //Storage Detail View with Custom Graph
//                        StorageDetailsView()
//                    }
//                }
//                .padding(.trailing, showStorageDetails ? (prop.size.width / 4) + 15 : 0)
//                .overlay(alignment: .topTrailing) {
//                    if showStorageDetails {
//                        StorageDetailsView()
//                            .frame(width: prop.size.width / 4)
//                    }
//                }
//            }
//            .padding()
//        }
//        .frame(maxWidth: .infinity)
//        .background {
//            Color.brown
//                .ignoresSafeArea()
//        }
//    }
//
//    //Custom Graph Properties
//    func getIndex(item: StorageDetail) -> Int {
//        return sampleStorageDetail.firstIndex{ index in
//            return index.id == item.id
//        } ?? 0
//    }
//
//    func getAngle(item: StorageDetail) -> Angle {
//        let index = getIndex(item: item)
//        let prefixItems = sampleStorageDetail.prefix(index)
//        var angle: Angle = .zero
//        for item in prefixItems {
//            angle += .init(degrees: (item.progress * 360))
//        }
//
//        return angle
//    }
//
//    @ViewBuilder
//    func StorageDetailsView() -> some View {
//        VStack(alignment: .leading, spacing: 15){
//            Text("Storage Details")
//                .font(.title3)
//                .bold()
//                .padding(.bottom, 10)
//
//            //MARK: Custom Graph
//            ZStack{
//                Circle()
//                    .stroke(Color.green, lineWidth: 25)
//
//                ForEach(sampleStorageDetail) { storage in
//                    let index = CGFloat(getIndex(item: storage))
//                    let progress = index / CGFloat(sampleStorageDetail.count)
//                    Circle()
//                        .trim(from: 0, to: storage.progress)
//                        .stroke(storage.progressColor, lineWidth: 35 - (10 * progress)) //35 - 10 = 25. This is to enable different width blocks on the circle graph
//                        .rotationEffect(.init(degrees: -90))
//                        .rotationEffect(getAngle(item: storage))
//                }
//
//                VStack {
//                    Text("29.1 %")
//                        .font(.largeTitle)
//                        .bold()
//
//                    Text("Of 625GB")
//                        .font(.callout)
//                        .fontWeight(.semibold)
//                }
//            }
//            .frame(height: 200)
//            .padding()
//            .padding(.bottom, 10)
//
//            ForEach(sampleStorageDetail) { item in
//                HStack(spacing: 15) {
//                    Image(item.icon)
//                        .resizedToFit(width: 30, height: 30)
//
//                    VStack(alignment: .leading, spacing: 6){
//                        Text(item.type)
//                            .font(.callout)
//                            .fontWeight(.semibold)
//                            .foregroundColor(.white.opacity(0.8))
//
//                        Text(item.files + " files")
//                            .font(.caption)
//                            .foregroundColor(.gray)
//                    }
//                    .frame(maxWidth: .infinity, alignment: .leading)
//
//                        Text(item.size)
//                            .font(.callout)
//                            .fontWeight(.semibold)
//                            .foregroundColor(.white.opacity(0.8))
//                }
//                .padding()
//                .background {
//                    RoundedRectangle(cornerRadius:8, style: .continuous)
//                        .strokeBorder(.white.opacity(0.2))
//                }
//                .padding(.top, 5)
//            }
//
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .padding()
//        .background {
//            RoundedRectangle(cornerRadius:8, style: .continuous)
//                .fill(.thinMaterial)
//        }
//        .padding(.top)
//    }
//
//    @ViewBuilder
//    func FilesView() -> some View {
//        VStack(alignment: .leading, spacing: 15){
//            Text("Recent Files")
//                .fontWeight(.semibold)
//                .foregroundColor(.white.opacity(0.8))
//
//            HStack(spacing: 0) {
//                ForEach(["File Name", "Date", "Size"], id: \.self) { type in
//                    Text(type)
//                        .fontWeight(.semibold)
//                        .italic()
//                        .frame(maxWidth: .infinity, alignment: type == "File Name" ? .leading : .center)
//                }
//            }
//            .foregroundColor(.white.opacity(0.8))
//
//            Rectangle()
//                .fill(.white.opacity(0.1))
//                .frame(height: 1)
//                .padding(.bottom, 10)
//
//            ForEach(sampleFile) { file in
//                HStack(spacing: 0) {
//                    Image(file.fileIcon)
//                        .resizedToFit(width: 25, height: 25)
//
//                    Text(file.fileType)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//
//                    Text(file.fileDate)
//                    .frame(maxWidth: .infinity, alignment: .center)
//
//                    Text(file.fileSize)
//                        .frame(maxWidth: .infinity, alignment: .trailing)
//
//                    Rectangle()
//                        .fill(.white.opacity(0.2))
//                        .frame(height: 1)
//                        .padding(.bottom, prop.isiPad ? 10 : 5)
//
//                }
//                .font(.system(size: prop.isiPad ? 18 : 14,weight: .semibold, design: .rounded))
//                .foregroundColor(.white.opacity(0.8))
//            }
//
//        }
//        .frame(maxWidth: .infinity, alignment: .leading)
//        .padding()
//        .background {
//            RoundedRectangle(cornerRadius:8, style: .continuous)
//                .fill(.thinMaterial)
//        }
//    }
//
//    @ViewBuilder
//    func OnlineStorageView() -> some View {
//        let count = (prop.isiPad && !prop.isSplit ? 1 : 2)
//        ScrollView(count == 1 ? .horizontal : .vertical, showsIndicators: false) {
//            DynamicLazyGrid(count: count) {
//                ForEach(sampleStorage) { storage in
//                    VStack(alignment: .leading, spacing: 15) {
//                        HStack {
//                            Image(storage.icon)
//                                .resizedToFit(width: 25, height: 25)
//                                .padding(10)
//                                .background {
//                                    Circle()
//                                        .fill(storage.progressColor.opacity(0.15))
//                                }
//
//                            Spacer(minLength: 5)
//
//                            Button {
//
//                            } label: {
//                                Image(systemName: "ellipsis")
//                                    .foregroundColor(.white.opacity(0.5))
//                                    .rotationEffect(.init(degrees: -90))
//
//                            }
//                        }
//                        
//                        Text(storage.title)
//                            .font(.callout)
//                            .fontWeight(.semibold)
//                            .foregroundColor(.white.opacity(0.8))
//                        
//                        GeometryReader{ geometry in
//                            let size = geometry.size
//                            ZStack(alignment: .leading){
//                                Capsule()
//                                    .fill(Color.white.opacity(0.1))
//
//                                Capsule()
//                                    .fill(storage.progressColor)
//                                    .frame(width: storage.progress * size.width)
//                            }
//                        }
//                        .frame(height: 4)
//                        
//                        HStack {
//                            Text("\(storage.fileCount) files")
//                                .font(.caption2)
//                                .foregroundColor(.white.opacity(0.7))
//
//                            Spacer(minLength: 5)
//
//                            Text(storage.maxSize)
//                            .font(.caption2)
//                            .bold()
//                            .foregroundColor(.white)
//                        }
//                    }
//                    .frame(width: count == 2 ? nil : 150)
//                    .padding()
//                    .background {
//                        RoundedRectangle(cornerRadius:8, style: .continuous)
//                            .fill(.thinMaterial)
//                    }
//                }
//            }
//        }
//    }
//
//    //MARK: Dynamic LazyGrid Content
//    @ViewBuilder
//    func DynamicLazyGrid<Content: View>(count: Int, @ViewBuilder content: @escaping () -> Content) -> some View {
//        if count == 1 {
//            LazyHGrid(rows: Array(repeating: GridItem(.flexible(), spacing: 10), count: 1), spacing: 15) {
//                content()
//            }
//        } else {
//            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 2), spacing: 15) {
//                content()
//            }
//        }
//    }
//
////    @ViewBuilder
////    func TopNavBar() -> some View {
////        HStack(spacing: 15) {
////            if prop.isiPad && !prop.isSplit {
////                Text("Dashboard")
////                    .font(.title3)
////                    .bold()
////            } else {
////                //menu button for sidebar
////                Button {
////                    withAnimation(.easeInOut) {
////                        showSideBar = true
////                    }
////                } label: {
////                    Image(systemName: "line.3.horizontal")
////                        .font(.title2)
////                        .foregroundColor(.white)
////
////                }
////            }
////
////            HStack {
////                TextField("Search", text: .constant(""))
////                    .padding(.leading, 10)
////
////                Button {
////
////                } label: {
////                    Image(systemName: "magnifyingglass")
////                        .foregroundColor(.white)
////                        .padding(12)
////                        .background (
////                            RoundedRectangle(cornerRadius:8, style: .continuous)
////                                .fill(Color.teal)
////                        )
////                }
////            }
////            .background (
////                RoundedRectangle(cornerRadius:8, style: .continuous)
////                    .fill(.thinMaterial)
////            )
////            .frame(maxWidth: 250)
////            .frame(maxWidth: .infinity, alignment: .trailing)
////
////            Button {
////
////            } label: {
////                Image("profile")
////                    .resizedToFill(width: 45, height: 45)
////                    .clipShape(Circle())
////            }
////
////        }
////    }
//}
//struct Dashboard_Previews: PreviewProvider {
//    static var previews: some View {
//        MainView()
//    }
//}
import SwiftUI
import RiveRuntime

struct WaypointView: View {
    var title = "Parked Car"
    var latitude = "35.08587 E"
    var longitude = "21.43573 W"
    var icon = "car.fill"
    var color = Color.blue
    var rotation: Double = 0
    var degrees: Double = 0
    
    var body: some View {
        ZStack {
            ZStack {
                Circle()
                    .fill(.white.opacity(0.05))
                    .frame(width: 120)
                Circle()
                    .stroke(.linearGradient(colors: [.white.opacity(0.3), .clear], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 120)
                    .overlay(
                        Circle().fill(color).frame(width: 28)
                            .overlay(Image(systemName: icon).font(.footnote).rotationEffect(.degrees(-degrees-rotation)))
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                    )
                Circle()
                    .fill(.white.opacity(0.02))
                    .frame(width: 80)
                Circle()
                    .stroke(.linearGradient(colors: [.white.opacity(0.3), .clear], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 80)
                Circle()
                    .fill(.white.opacity(0.02))
                    .frame(width: 20)
                Circle()
                    .stroke(.linearGradient(colors: [.white.opacity(0.3), .clear], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 20)
            }
            .rotationEffect(.degrees(degrees+rotation))
            
            VStack(spacing: 4) {
                Text(title)
                Text(latitude)
                    .font(.footnote).opacity(0.5)
                Text(longitude)
                    .font(.footnote).opacity(0.5)
            }
            .foregroundColor(.white)
        }
    }
}

struct InfoRow: View {
    var title: String
    var text: String
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title.uppercased()).font(.caption)
                .opacity(0.5)
            Text(text)
        }
    }
}

//
//  ContentView.swift
//  CompassApp
//
//  Created by Meng To on 2022-11-25.
//

import SwiftUI



//
//  CompassSheet.swift
//  CompassApp
//
//  Created by Meng To on 2022-11-25.
//

import SwiftUI

struct OldCompassSheet: View {
    @Binding var degrees: Double
    @Binding var show: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 30) {
                InfoRow(title: "Incline", text: "20º")
                InfoRow(title: "Elevation", text: "64M")
                InfoRow(title: "Latitude", text: "35.08587 E")
                InfoRow(title: "Longitude", text: "48.1255 W")
                ZStack {
                    Circle()
                        .strokeBorder(.white.opacity(0.4), style: StrokeStyle(lineWidth: 5, dash: [1,2]))
                    Circle()
                        .strokeBorder(.white.opacity(0.4), style: StrokeStyle(lineWidth: 15, dash: [1,60]))
                    Image("arrow").rotationEffect(.degrees(degrees))
                }
                .frame(width: 93, height: 93)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .mask {
                Rectangle().fill(.linearGradient(colors: [.white, .white, .white.opacity(0.5), .clear], startPoint: .top, endPoint: .bottom))
            }
            .opacity(show ? 1 : 0)
            .blur(radius: show ? 0 : 20)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("Waypoints".uppercased())
                    .font(.caption.weight(.medium))
                    .opacity(0.5)
                WaypointView(rotation: 200, degrees: degrees)
                WaypointView(title: "Home", icon: "house.fill", color: .red, rotation: 10, degrees: degrees)
                WaypointView(title: "Tent", icon: "tent.fill", color: .green, rotation: 90, degrees: degrees)
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .opacity(show ? 1 : 0)
            .blur(radius: show ? 0 : 20)
        }
        .foregroundColor(.white)
        .padding(40)
        .preferredColorScheme(.dark)
    }
}

struct OldCompassSheet_Previews: PreviewProvider {
    static var previews: some View {
        OldCompassSheet(degrees: .constant(0), show: .constant(true))
            .ignoresSafeArea(edges: .bottom)
    }
}

struct CircleLabelView: View {
    var radius: Double
    var text: String
    var kerning: CGFloat = 4
    var size: CGSize = .init(width: 300, height: 300)
    
    var texts: [(offset: Int, element: Character)] {
        return Array(text.enumerated())
    }
    
    @State var textWidths: [Int:Double] = [:]
    
    var body: some View {
        ZStack {
            ForEach(texts, id: \.offset) { index, letter in
                VStack {
                    Text(String(letter))
                        .kerning(kerning)
                        .background(Sizeable())
                        .onPreferenceChange(WidthPreferenceKey.self, perform: { width in
                            textWidths[index] = width
                        })
                    Spacer()
                }
                .rotationEffect(angle(at: index))
            }
        }
        .rotationEffect(-angle(at: texts.count-1)/2)
        .frame(width: size.width, height: size.height)
    }
    
    func angle(at index: Int) -> Angle {
        guard let labelWidth = textWidths[index] else { return .radians(0) }
        
        let circumference = radius * 2 * .pi
        
        let percent = labelWidth / circumference
        let labelAngle = percent * 2 * .pi
        
        let widthBeforeLabel = textWidths.filter{$0.key < index}.map{$0.value}.reduce(0, +)
        let percentBeforeLabel = widthBeforeLabel / circumference
        let angleBeforeLabel = percentBeforeLabel * 2 * .pi
        
        return .radians(angleBeforeLabel + labelAngle)
    }
}

struct CircleLabelView_Previews: PreviewProvider {
    static var previews: some View {
        CircleLabelView(
            radius: 150,
            text: "Latitude 35.08587 E • Longitude 21.43673 W • Elevation 64M • Incline 12 •".uppercased()
        )
        .font(.system(size: 13, design: .monospaced))
    }
}

struct WidthPreferenceKey: PreferenceKey {
    static var defaultValue: Double = 0
    static func reduce(value: inout Double, nextValue: () -> Double) {
        value = nextValue()
    }
}

struct Sizeable: View {
    var body: some View {
        GeometryReader { geometry in
            Color.clear
                .preference(key: WidthPreferenceKey.self, value: geometry.size.width)
        }
    }
}


//parallaxMotionModifier
import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {

    @Published var pitch: Double = 0.0
    @Published var roll: Double = 0.0
    @Published var rotation: Double = 0.0
    
    var motion: CMMotionManager

    init() {
        motion = CMMotionManager()
        motion.deviceMotionUpdateInterval = 1/60
        motion.startDeviceMotionUpdates(to: .main) { (motionData, error) in
            guard error == nil else { return }

            if let motionData = motionData {
                self.pitch = motionData.attitude.pitch
                self.roll = motionData.attitude.roll
                self.rotation = motionData.rotationRate.x
            }
        }
    }
}



@available(iOS 16.0, *)
///Only available for use in iOS 16 upwards
struct GrayBackground: View {
     
    var body: some View {
        ZStack {
            Rectangle()
                .fill(.gray.gradient)
                .ignoresSafeArea()
            
            clockCase
            
            
            Circle()
                .strokeBorder(.black, style: StrokeStyle(lineWidth: 10, dash: [1, 10]))
                .frame(width: 220)
            
        }
    }
    
    
    var clockCase: some View {
        ZStack {
            Circle()
                .foregroundStyle(
                    .gray
                    .shadow(.inner(color: .gray, radius: 30, x: 30, y: 30))
                    .shadow(.inner(color: .white.opacity(0.2), radius: 0, x: -1, y: -1))
                    .shadow(.inner(color: .black.opacity(0.2), radius: 0, x: 1, y: 1))
                )
                .frame(width: 360)
            
            Circle()
                .foregroundStyle(
                    .white
                    .shadow(.inner(color: .gray, radius: 30, x: -30, y: -30))
                    .shadow(.drop(color: .black.opacity(0.3), radius: 30, x: 30, y: 30))
                )
                .frame(width: 320)
            
            Circle()
                .foregroundStyle(.white.shadow(.inner(color: .gray, radius: 30, x: 30, y: 30)))
                .frame(width: 280)
        }
    }
}

@available(iOS 16.0, *)
struct GrayBackground_Previews: PreviewProvider {
    static var previews: some View {
        GrayBackground()
    }
}

@available(iOS 16.0, *)
struct RadialLayout: Layout {
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        return proposal.replacingUnspecifiedDimensions()
    }
    
    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        
    }
}


#warning("first milepost")

struct ContentView: View {
    @State var show = false
    @State var isOpen = false
    var button = RiveViewModel(fileName: "menu_button", stateMachineName: "State Machine", autoplay: false, animationName: "open")
    
    var body: some View {
        ZStack {
            Color(hex: "17203A").ignoresSafeArea()
            
            SideMenu()
                .padding(.top, 50)
                .opacity(isOpen ? 1 : 0)
                .offset(x: isOpen ? 0 : -300)
                .rotation3DEffect(.degrees(isOpen ? 0 : 30), axis: (x: 0, y: 1, z: 0))
                .ignoresSafeArea(.all, edges: .top)
            
            HomeView()
                .safeAreaInset(edge: .bottom) {
                    Color.clear.frame(height: 80)
                }
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 104)
                }
                .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                .rotation3DEffect(.degrees(isOpen ? 30 : 0), axis: (x: 0, y: -1, z: 0), perspective: 1)
                .offset(x: isOpen ? 265 : 0)
                .scaleEffect(isOpen ? 0.9 : 1)
                .scaleEffect(show ? 0.92 : 1)
                .ignoresSafeArea()
            
            TabBar()
                .offset(y: -24)
                .background(
                    LinearGradient(colors: [Color("Background").opacity(0), Color("Background")], startPoint: .top, endPoint: .bottom)
                        .frame(height: 150)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .allowsHitTesting(false)
                )
                .ignoresSafeArea()
                .offset(y: isOpen ? 300 : 0)
                .offset(y: show ? 200 : 0)
            
            button.view()
                .frame(width: 44, height: 44)
                .mask(Circle())
                .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x: 0, y: 5)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
                .offset(x: isOpen ? 216 : 0)
                .onTapGesture {
                    try? button.setInput("isOpen", value: isOpen)
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                        isOpen.toggle()
                    }
                }
                .onChange(of: isOpen) { newValue in
                    if newValue {
                        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
                    } else {
                        UIApplication.shared.setStatusBarStyle(.darkContent, animated: true)
                    }
                }
            
            Image(systemName: "person")
                .frame(width: 36, height: 36)
                .background(.white)
                .mask(Circle())
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .shadow(color: Color("Shadow").opacity(0.2), radius: 5, x: 0, y: 5)
                .padding()
                .offset(y: 4)
                .offset(x: isOpen ? 100 : 0)
                .onTapGesture {
                    withAnimation(.spring()) {
                        show.toggle()
                    }
                }
            
            if show {
                OnboardingView(show: $show)
                    .background(.white)
                    .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
                    .shadow(color: .black.opacity(0.5), radius: 40, x: 0, y: 40)
                    .ignoresSafeArea(.all, edges: .top)
                    .offset(y: show ? -10 : 0)
                    .zIndex(1)
                    .transition(.move(edge: .top))
            }
        }
    }
}

extension UIViewController {
    func setStatusBarStyle(_ style: UIStatusBarStyle) {
        if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = style == .lightContent ? UIColor.black : .white
            statusBar.setValue(style == .lightContent ? UIColor.white : .black, forKey: "foregroundColor")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

#warning("second milepost")

struct AnimatedHomeView: View {
    var body: some View {
        ZStack {
            Color("Background").ignoresSafeArea()
            
            ScrollView {
                content
            }
        }
    }
    
    var content: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Courses")
                    .customFont(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(courses) { course in
                        VCard(course: course)
                    }
                }
                .padding(20)
                .padding(.bottom, 10)
            }
            
            VStack {
                Text("Recent")
                    .customFont(.title3)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(spacing: 20) {
                    ForEach(courseSections) { section in
                        HCard(section: section)
                    }
                }
            }
            .padding(20)
        }
    }
}

struct AnimatedHomeView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedHomeView()
    }
}

#warning("third milepost")

struct HCard: View {
    var section = courseSections[0]
    
    var body: some View {
        HStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text(section.title)
                    .customFont(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(section.caption)
                    .customFont(.body)
            }
            Divider()
            section.image
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: 110)
        .foregroundColor(.white)
        .background(section.color)
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
    }
}

struct HCard_Previews: PreviewProvider {
    static var previews: some View {
        HCard()
    }
}

#warning("fourth milepost")

struct VCard: View {
    var course: Course
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(course.title)
                .customFont(.title2)
                .frame(maxWidth: 170, alignment: .leading)
                .layoutPriority(1)
            Text(course.subtitle)
                .opacity(0.7)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(course.caption.uppercased())
                .customFont(.footnote2)
                .opacity(0.7)
            Spacer()
            HStack {
                ForEach(Array([4, 5, 6].shuffled().enumerated()), id: \.offset) { index, number in
                    Image("Avatar \(number)")
                        .resizable()
                        .mask(Circle())
                        .frame(width: 44, height: 44)
                        .offset(x: CGFloat(index * -20))
                }
            }
        }
        .foregroundColor(.white)
        .padding(30)
        .frame(width: 260, height: 310)
        .background(.linearGradient(colors: [course.color.opacity(1), course.color.opacity(0.5)], startPoint: .topLeading, endPoint: .bottomTrailing))
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: course.color.opacity(0.3), radius: 8, x: 0, y: 12)
        .shadow(color: course.color.opacity(0.3), radius: 2, x: 0, y: 1)
        .overlay(
            course.image
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(20)
        )
    }
}

struct VCard_Previews: PreviewProvider {
    static var previews: some View {
        VCard(course: courses[1])
    }
}

#warning("fifth milepost")

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

#warning("sixth milepost")

struct CustomButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(16)
            .padding(.horizontal, 8)
            .background(.white)
            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .foregroundStyle(.primary)
            .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 10)
    }
}

extension View {
    func customButton() -> some View {
        modifier(CustomButton())
    }
}

struct NewLargeButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(Color(hex: "F77D8E"))
            .foregroundColor(.white)
            .mask(RoundedCorner(radius: 20, corners: [.topRight, .bottomLeft, .bottomRight]))
            .mask(RoundedRectangle(cornerRadius: 8))
            .shadow(color: Color(hex: "F77D8E").opacity(0.5), radius: 20, x: 0, y: 10)
    }
}

extension View {
    func largeButton() -> some View {
        modifier(NewLargeButton())
    }
}

#warning("seventh milepost")

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

#warning("eighth milepost")

struct CustomTextField: ViewModifier {
    var image: Image
    func body(content: Content) -> some View {
        content
            .padding(15)
            .padding(.leading, 36)
            .background(.white)
            .mask(RoundedRectangle(cornerRadius: 10, style: .continuous))
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(lineWidth: 1).fill(.black.opacity(0.1)))
            .overlay(image.frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 8))
    }
}

extension View {
    func customTextField(image: Image) -> some View {
        modifier(CustomTextField(image: image))
    }
}

#warning("ninth milepost")

struct Course: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var caption: String
    var color: Color
    var image: Image
}

var courses = [
    Course(title: "Animations in SwiftUI", subtitle: "Build and animate an iOS app from scratch", caption: "20 sections - 3 hours", color: Color(hex: "7850F0"), image: Image("Topic 1")),
    Course(title: "Build Quick Apps with SwiftUI", subtitle: "Apply your Swift and SwiftUI knowledge by building real, quick and various applications from scratch", caption: "47 sections - 11 hours", color: Color(hex: "6792FF"), image: Image("Topic 2")),
    Course(title: "Build a SwiftUI app for iOS 15", subtitle: "Design and code a SwiftUI 3 app with custom layouts, animations and gestures using Xcode 13, SF Symbols 3, Canvas, Concurrency, Searchable and a whole lot more", caption: "21 sections - 4 hours", color: Color(hex: "005FE7"), image: Image("Topic 1"))
]

#warning("tenth milepost")

struct CourseSection: Identifiable {
    var id = UUID()
    var title: String
    var caption: String
    var color: Color
    var image: Image
}

var courseSections = [
    CourseSection(title: "State Machine", caption: "Watch video - 15 mins", color: Color(hex: "9CC5FF"), image: Image("Topic 2")),
    CourseSection(title: "Animated Menu", caption: "Watch video - 10 mins", color: Color(hex: "6E6AE8"), image: Image("Topic 1")),
    CourseSection(title: "Tab Bar", caption: "Watch video - 8 mins", color: Color(hex: "005FE7"), image: Image("Topic 2")),
    CourseSection(title: "Button", caption: "Watch video - 9 mins", color: Color(hex: "BBA6FF"), image: Image("Topic 1"))
]

#warning("eleventh milepost")

struct TabBar: View {
    @AppStorage("selectedTab") var selectedTab: Tab = .chat
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                content
            }
            .frame(maxWidth: .infinity)
            .padding(12)
            .background(Color("Background 2").opacity(0.8))
            .background(.ultraThinMaterial)
            .mask(RoundedRectangle(cornerRadius: 26, style: .continuous))
            .shadow(color: Color("Background 2").opacity(0.3), radius: 20, x: 0, y: 20)
            .overlay(
                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .stroke(.linearGradient(colors: [.white.opacity(0.5), .white.opacity(0)], startPoint: .topLeading, endPoint: .bottomTrailing))
            )
            .padding(.horizontal, 24)
        }
    }
    
    var content: some View {
        ForEach(tabItems) { item in
            Button {
                try? item.icon.setInput("active", value: true)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    try? item.icon.setInput("active", value: false)
                }
                withAnimation {
                    selectedTab = item.tab
                }
            } label: {
                item.icon.view()
                    .frame(width: 36, height: 36)
                    .frame(maxWidth: .infinity)
                    .opacity(selectedTab == item.tab ? 1 : 0.5)
                    .background(
                        VStack {
                            RoundedRectangle(cornerRadius: 2)
                                .frame(width: selectedTab == item.tab ? 20 : 0, height: 4)
                                .offset(y: -4)
                                .opacity(selectedTab == item.tab ? 1 : 0)
                            Spacer()
                        }
                    )
            }
        }
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        TabBar()
    }
}

struct TabItem: Identifiable {
    var id = UUID()
    var icon: RiveViewModel
    var tab: Tab
}

var tabItems = [
    TabItem(icon: RiveViewModel(fileName: "icons", stateMachineName: "CHAT_Interactivity", artboardName: "CHAT"), tab: .chat),
    TabItem(icon: RiveViewModel(fileName: "icons", stateMachineName: "SEARCH_Interactivity", artboardName: "SEARCH"), tab: .search),
    TabItem(icon: RiveViewModel(fileName: "icons", stateMachineName: "TIMER_Interactivity", artboardName: "TIMER"), tab: .timer),
    TabItem(icon: RiveViewModel(fileName: "icons", stateMachineName: "BELL_Interactivity", artboardName: "BELL"), tab: .bell),
    TabItem(icon: RiveViewModel(fileName: "icons", stateMachineName: "USER_Interactivity", artboardName: "USER"), tab: .user)
]

enum Tab: String {
    case chat
    case search
    case timer
    case bell
    case user
}

#warning("twelfth milepost")

struct SideMenu: View {
    @State var isDarkMode = false
    @AppStorage("selectedMenu") var selectedMenu: SelectedMenu = .home
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "person.fill")
                    .padding(12)
                    .background(.white.opacity(0.2))
                    .mask(Circle())
                VStack(alignment: .leading, spacing: 2) {
                    Text("Meng To")
                    Text("UI Designer")
                        .font(.subheadline)
                        .opacity(0.7)
                }
                Spacer()
            }
            .padding()
            
            Text("BROWSE")
                .font(.subheadline).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 40)
                .opacity(0.7)
            
            browse
            
            Text("HISTORY")
                .font(.subheadline).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 40)
                .opacity(0.7)
            
            history
            
            Spacer()
            
            HStack(spacing: 14) {
                menuItems3[0].icon.view()
                    .frame(width: 32, height: 32)
                    .opacity(0.6)
                    .onChange(of: isDarkMode) { newValue in
                        if newValue {
                            try? menuItems3[0].icon.setInput("active", value: true)
                        } else {
                            try? menuItems3[0].icon.setInput("active", value: false)
                        }
                    }
                Text(menuItems3[0].text)
                
                Toggle("", isOn: $isDarkMode)
            }
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(12)
            .mask(RoundedRectangle(cornerRadius: 20, style: .continuous))
            .padding(8)
        }
        .foregroundColor(.white)
        .frame(maxWidth: 288, maxHeight: .infinity)
        .background(Color(hex: "17203A"))
        .mask(RoundedRectangle(cornerRadius: 30, style: .continuous))
        .shadow(color: Color(hex: "17203A").opacity(0.3), radius: 40, x: 0, y: 20)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    var browse: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(menuItems) { item in
                Rectangle()
                    .frame(height: 1)
                    .opacity(0.1)
                    .padding(.horizontal, 16)
                
                HStack(spacing: 14) {
                    item.icon.view()
                        .frame(width: 32, height: 32)
                        .opacity(0.6)
                    Text(item.text)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.blue)
                        .frame(maxWidth: selectedMenu == item.menu ? .infinity : 0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                )
                .background(Color("Background 2"))
                .onTapGesture {
                    withAnimation(.timingCurve(0.2, 0.8, 0.2, 1)) {
                        selectedMenu = item.menu
                    }
                    try? item.icon.setInput("active", value: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        try? item.icon.setInput("active", value: false)
                    }
                }
            }
        }
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
    }
    
    var history: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(menuItems2) { item in
                Rectangle()
                    .frame(height: 1)
                    .opacity(0.1)
                    .padding(.horizontal, 16)
                
                HStack(spacing: 14) {
                    item.icon.view()
                        .frame(width: 32, height: 32)
                        .opacity(0.6)
                    Text(item.text)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(12)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(.blue)
                        .frame(maxWidth: selectedMenu == item.menu ? .infinity : 0)
                        .frame(maxWidth: .infinity, alignment: .leading)
                )
                .background(Color("Background 2"))
                .onTapGesture {
                    withAnimation(.timingCurve(0.2, 0.8, 0.2, 1)) {
                        selectedMenu = item.menu
                    }
                    try? item.icon.setInput("active", value: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        try? item.icon.setInput("active", value: false)
                    }
                }
            }
        }
        .font(.headline)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
    }
}

struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        SideMenu()
    }
}

struct MenuItem: Identifiable {
    var id = UUID()
    var text: String
    var icon: RiveViewModel
    var menu: SelectedMenu
}

var menuItems = [
    MenuItem(text: "Home", icon: RiveViewModel(fileName: "icons", stateMachineName: "HOME_interactivity", artboardName: "HOME"), menu: .home),
    MenuItem(text: "Search", icon: RiveViewModel(fileName: "icons", stateMachineName: "SEARCH_Interactivity", artboardName: "SEARCH"), menu: .search),
    MenuItem(text: "Favorites", icon: RiveViewModel(fileName: "icons", stateMachineName: "STAR_Interactivity", artboardName: "LIKE/STAR"), menu: .favorites),
    MenuItem(text: "Help", icon: RiveViewModel(fileName: "icons", stateMachineName: "CHAT_Interactivity", artboardName: "CHAT"), menu: .help)
]

var menuItems2 = [
    MenuItem(text: "History", icon: RiveViewModel(fileName: "icons", stateMachineName: "TIMER_Interactivity", artboardName: "TIMER"), menu: .history),
    MenuItem(text: "Notifications", icon: RiveViewModel(fileName: "icons", stateMachineName: "BELL_Interactivity", artboardName: "BELL"), menu: .notifications)
]

var menuItems3 = [
    MenuItem(text: "Dark Mode", icon: RiveViewModel(fileName: "icons", stateMachineName: "SETTINGS_Interactivity", artboardName: "SETTINGS"), menu: .darkmode)
]

enum SelectedMenu: String {
    case home
    case search
    case favorites
    case help
    case history
    case notifications
    case darkmode
}

#warning("thirteenth milepost")




