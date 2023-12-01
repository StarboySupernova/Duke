//
//  TaskModel.swift
//  Duke
//
//  Created by user226714 on 10/29/23.
//

import Foundation
import SwiftUI

///---------------------Task Model
struct DropTask: Identifiable, Hashable {
    var id: UUID = .init()
    var title: String
    var status: DropStatus
}

enum DropStatus {
    case todo
    case working
    case completed
}
