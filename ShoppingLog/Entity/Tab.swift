//
//  Tab.swift
//  ShoppingLog
//
//  Created by Ryuga on 2023/12/31.
//

import SwiftUI

enum Tab: String {
    case logsList = "Logs List"
    case settings = "Settings"

    @ViewBuilder
    var tabCount: some View {
        switch self {
        case .logsList:
            Image(systemName: "cart")
            Text(self.rawValue)
        case .settings:
            Image(systemName: "gearshape")
            Text(self.rawValue)
        }
    }
}
