//
//  SortOption.swift
//  ShoppingLog
//
//  Created by Ryuga on 2023/12/29.
//

import Foundation

enum SortOption: String, CaseIterable {
    case title
    case location
    case date
}

extension SortOption {

    var systemImage: String {
        switch self {
        case .title:
            "textformat.size.larger"
        case .location:
            "mappin.and.ellipse"
        case .date:
            "calendar"
        }
    }
}
