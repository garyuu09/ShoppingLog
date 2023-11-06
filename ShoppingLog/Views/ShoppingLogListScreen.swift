//
//  ShoppingLogListScreen.swift
//  ShoppingLog
//
//  Created by Ryuga on 2023/10/27.
//

import SwiftUI
import SwiftData

struct ShoppingLogListScreen: View {
    @State private var image: UIImage?
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $selectedTab) {
                    /// Logs Listのタブ
                    ShoppingLogListView()
                        .tabItem {
                            Image(systemName: "cart")
                            Text("Logs List")
                        }
                        .tag(0)
                    /// Settingsのタブ
                    SettingView()
                        .tabItem {
                            Image(systemName: "gearshape")
                            Text("Settings")
                        }
                        .tag(1)
                }
                .accentColor(.white)
            }
        }
    }
}

#Preview {
    ShoppingLogListScreen()
        .modelContainer(for: Item.self, inMemory: true)
}
