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
//  CompassSheet.swift
//  CompassApp
//
//  Created by Meng To on 2022-11-25.
//

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

//struct OldCompassSheet_Previews: PreviewProvider {
//    static var previews: some View {
//        OldCompassSheet(degrees: .constant(0), show: .constant(true))
//            .ignoresSafeArea(edges: .bottom)
//    }
//}

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

//struct CircleLabelView_Previews: PreviewProvider {
//    static var previews: some View {
//        CircleLabelView(
//            radius: 150,
//            text: "Latitude 35.08587 E • Longitude 21.43673 W • Elevation 64M • Incline 12 •".uppercased()
//        )
//        .font(.system(size: 13, design: .monospaced))
//    }
//}

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
//struct GrayBackground_Previews: PreviewProvider {
//    static var previews: some View {
//        GrayBackground()
//    }
//}

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


struct Course: Identifiable, Hashable {
    var id = UUID()
    var title: String
    var subtitle: String
    var color: Color
    var image: String
    var logo: String
    var show: Bool
    var index: Double
}

var courses = [
    Course(
        title: "UI Design for iOS 14",
        subtitle: "20 sections",
        color: Color(#colorLiteral(red: 0, green: 0.5217629075, blue: 1, alpha: 1)),
        image: "Illustration 1",
        logo: "Logo UI Design",
        show: false,
        index: -1
    ),
    Course(
        title: "Build a SwiftUI app for iOS 14",
        subtitle: "20 sections",
        color: Color(#colorLiteral(red: 0.3150139749, green: 0, blue: 0.8982304931, alpha: 1)),
        image: "Illustration 2",
        logo: "Logo SwiftUI",
        show: false,
        index: -1
    ),
    Course(
        title: "UI Design for iPadOS",
        subtitle: "12 sections",
        color: Color(#colorLiteral(red: 0, green: 0.7283110023, blue: 1, alpha: 1)),
        image: "Illustration 3",
        logo: "Logo UI Design",
        show: false,
        index: -1
    ),
    Course(
        title: "UI Design for macOS",
        subtitle: "12 sections",
        color: Color(#colorLiteral(red: 0.9467853904, green: 0.2021691203, blue: 0.3819385171, alpha: 1)),
        image: "Illustration 4",
        logo: "Logo UI Design",
        show: false,
        index: -1
    ),
    Course(
        title: "Build a SwiftUI app for iOS 13",
        subtitle: "60 sections",
        color: Color(#colorLiteral(red: 0.9721538424, green: 0.2151708901, blue: 0.5066347718, alpha: 1)),
        image: "Illustration 5",
        logo: "Logo SwiftUI",
        show: false,
        index: -1
    ),
    Course(
        title: "Design System in Figma",
        subtitle: "12 sections",
        color: Color(#colorLiteral(red: 1, green: 0.3477956653, blue: 0.3974102139, alpha: 1)),
        image: "Illustration 6",
        logo: "Logo Figma",
        show: false,
        index: -1
    ),
    Course(
        title: "React for designers",
        subtitle: "12 sections",
        color: Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)),
        image: "Illustration 7",
        logo: "Logo React",
        show: false,
        index: -1
    ),
    Course(
        title: "UI Design for developers",
        subtitle: "20 sections",
        color: Color(#colorLiteral(red: 0.1446507573, green: 0.8378821015, blue: 0.9349924922, alpha: 1)),
        image: "Illustration 8",
        logo: "Logo UI Design",
        show: false,
        index: -1
    )
]










