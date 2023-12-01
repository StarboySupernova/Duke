//
//  HookReleaseView.swift
//  Duke
//
//  Created by Simbarashe Dombodzvuku on 10/29/23.
//

import SwiftUI
import ExtensionKit

@available(iOS 16.0, *)
struct HookReleaseView: View {
    ///Sample Tasks
    @State private var todo: [DropTask] = [ .init(title: "Edit Video", status: .todo)]
    @State private var working: [DropTask] = [.init(title: "Record Video", status: .working)]
    @State private var completed: [DropTask] = [.init(title: "Implement drag & drop", status: .completed), .init(title:"Update MockView App", status: .completed)]
    
    @State private var currentlyDragging: DropTask?
    let business: Business
    
    var body: some View {
        HStack(spacing: 2){
            TodoView()
            
            WorkingView()
            
            CompletedView()
        }
    }
    
    @ViewBuilder func TasksView(_ tasks: [DropTask]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(tasks) { task in
                GeometryReader { geometry in
                    TaskRow(task, geometry.size)
                }
                .frame(height: 100) 
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    @ViewBuilder func TaskRow(_ task: DropTask, _ size: CGSize) -> some View {
        HStack(alignment: .bottom) {
            //Labels
            VStack(alignment: .leading, spacing: .small) {
                Text(business.formattedName)
                Text(business.formattedCategory)
                HStack {
                    Text(business.formattedRating)
                    Image("star")
                }
            }
            .foregroundColor(.white)
            
            Spacer()
            
            AsyncImage(url: URL("business.formattedImageURL") ) { image in
                image
                    .resizable()
            } placeholder: {
                Color.blue.shimmer()
            }
            .frame(width: 90, height: 70)
            .cornerRadius(10)
            .padding(.small)
//            .modifier(CompactConvexGlassView())
        }
            .foregroundColor(.white)
            .font(.callout)
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: size.height)
            .background(Color("Background 2"), in: Trapezoid())
            .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 10))
            .draggable(task.id.uuidString) {
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: .small) {
                        Text(business.formattedName)
                        Text(business.formattedCategory)
                        HStack {
                            Text(business.formattedRating)
                            Image("star")
                        }
                    }
                    .foregroundColor(.white)
                    
                    Spacer()
                    
                    AsyncImage(url: URL("business.formattedImageURL") ) { image in
                        image
                            .resizable()
                    } placeholder: {
                        Color.blue.shimmer()
                    }
                    .frame(width: 90, height: 70)
                    .cornerRadius(10)
                    .padding(.small)
//                    .modifier(CompactConvexGlassView())
                }
                    .font(.callout)
                    .padding(.horizontal, 15)
                    .frame(width: size.width, height: size.height, alignment: .leading)
                    .background(.white)
                    .contentShape(.dragPreview, RoundedRectangle(cornerRadius: 10))
                    .onAppear(perform: {
                        currentlyDragging = task
                    })
            }
            .dropDestination(for: String.self) { items, location in
                currentlyDragging = nil
                return false
            } isTargeted: { status in
                if let currentlyDragging, status, currentlyDragging.id != task.id {
                    withAnimation(.spring()) {
                        appendTask(task.status)
                        switch task.status {
                        case .todo:
                            replaceItem(tasks: &todo, droppingTask: task, status: .todo)
                        case .working:
                            replaceItem(tasks: &working, droppingTask: task, status: .working)
                        case .completed:
                            replaceItem(tasks: &completed, droppingTask: task, status: .completed)
                        }
                    }
                }
            }
    }
    
    ///Appending & removing task from one List to another List
    func appendTask(_ status: DropStatus) {
        if let currentlyDragging {
            switch status {
            case .todo:
                if !todo.contains(where: { $0.id == currentlyDragging.id}) {
                    var updatedTask = currentlyDragging
                    updatedTask.status = .todo
                    todo.append(updatedTask)
                    working.removeAll(where: { $0.id == currentlyDragging.id})
                    completed.removeAll(where: {$0.id == currentlyDragging.id})
                    
                }
            case .working:
                if !working.contains(where: { $0.id == currentlyDragging.id}) {
                    var updatedTask = currentlyDragging
                    updatedTask.status = .working
                    working.append(updatedTask)
                    todo.removeAll(where: { $0.id == currentlyDragging.id})
                    completed.removeAll(where: {$0.id == currentlyDragging.id})
                    
                }
            case .completed:
                if !completed.contains(where: { $0.id == currentlyDragging.id}) {
                    var updatedTask = currentlyDragging
                    updatedTask.status = .completed
                    completed.append(updatedTask)
                    working.removeAll(where: { $0.id == currentlyDragging.id})
                    todo.removeAll(where: {$0.id == currentlyDragging.id})
                }
            }
        }
    }
    
    func replaceItem(tasks: inout [DropTask], droppingTask: DropTask, status: DropStatus) {
        if let currentlyDragging {
            if let sourceIndex = tasks.firstIndex(where: {$0.id == currentlyDragging.id}), let destinationIndex = tasks.firstIndex(where: { $0.id == droppingTask.id}) {
                ///Swapping Items on the same List
                var sourceItem = tasks.remove(at: sourceIndex)
                sourceItem.status = status
                tasks.insert(sourceItem, at: destinationIndex)
            }
        }
    }
    
    @ViewBuilder func TodoView() -> some View{
        NavigationStack {
            ScrollView {
                TasksView(todo)
            }
            .navigationTitle("Todo")
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .contentShape(Rectangle())
            .dropDestination(for: String.self) { items, location in
                ///Appending to the last position on the current list, if the item isn't present on that list
                withAnimation(.spring()) {
                    appendTask(.todo)
                }
                return true
            } isTargeted: { _ in
                
            }
        }
    }
    
    @ViewBuilder func WorkingView() -> some View{
        NavigationStack {
            ScrollView {
                TasksView(working)
            }
            .navigationTitle("Working")
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .contentShape(Rectangle())
            .dropDestination(for: String.self) { items, location in
                withAnimation(.spring()){
                    appendTask(.working)
                }
                return true
            } isTargeted: { _ in
                
            }
        }
    }
    
    @ViewBuilder func CompletedView() -> some View{
        NavigationStack {
            ScrollView {
                TasksView(completed)
            }
            .navigationTitle("Completed")
            .frame(maxWidth: .infinity)
            .background(.ultraThinMaterial)
            .contentShape(Rectangle())
            .dropDestination(for: String.self) { items, location in
                withAnimation(.spring()) {
                    appendTask(.completed)
                }
                return true
            } isTargeted: { _ in
                
            }
        }
    }

}

@available(iOS 16.0, *)
struct HookReleaseView_Previews: PreviewProvider {
    static var previews: some View {
        HookReleaseView(business: Business(alias: nil, categories: [.init(alias: nil, title: "Cafe")], coordinates: nil, displayPhone: nil, distance: nil, id: nil, imageURL: "https://loremflickr.com/g/620/440/paris", isClosed: nil, location: nil, name: "Blue bottle", phone: nil, price: nil, rating: 4.5, reviewCount: nil, transactions: nil, url: nil))
            .previewInterfaceOrientation(.landscapeRight)
    }
}
