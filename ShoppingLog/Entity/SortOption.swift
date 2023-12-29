//
//  SortOption.swift
//  ShoppingLog
//
//  Created by Ryuga on 2023/12/29.
//

import Foundation

enum SortOption: String, CaseIterable {
    case title
    case date
    case category
}

extension SortOption {

    var systemImage: String {
        switch self {
        case .title:
            "textformat.size.larger"
        case .date:
            "calendar"
        case .category:
            "folder"
        }
    }
}
