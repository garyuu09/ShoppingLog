//
//  Item.swift
//  ShoppingLog
//
//  Created by Ryuga on 2023/10/27.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    var title: String
    @Attribute(.externalStorage)
    var image: Data?

    init(timestamp: Date = .now, title: String = "") {
        self.timestamp = timestamp
        self.title = title
    }
}
