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
    @State private var selectedTab: Tab = .logsList

    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $selectedTab) {
                    ShoppingLogListView()
                        .tag(Tab.logsList)
                        .tabItem { Tab.logsList.tabContent }

                    SettingView()
                        .tag(Tab.settings)
                        .tabItem { Tab.settings.tabContent }
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
