//
//  ContentView.swift
//  ShoppingLog
//
//  Created by Ryuga on 2023/10/27.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var image: UIImage?
    @State private var showCreateLogView = false
    @State private var searchQuery = ""
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            VStack {
                TabView(selection: $selectedTab) {
                    NavigationStack {
                        VStack {
                            List {
                                ForEach(items) { item in
                                    NavigationLink {
                                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                                        EditLogView(item: item)

                                    } label: {
                                        HStack {
                                            VStack(alignment: .leading, spacing: 2) {
                                                // タイトル
                                                Text(item.title)
                                                    .font(.subheadline)
                                                    .foregroundColor(.white)
                                                // 日付
                                                // MARK: 2023/10/27 という形に修正したい
                                                Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                                            }
                                            AlbumItemView(item: item)
                                        }
                                    }
                                }
                                .onDelete(perform: deleteItems)
                                .padding(.all, 5)
                                .frame(maxWidth: .infinity, maxHeight: 70)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .foregroundStyle(Color.gray)
                            }
                            .listStyle(.plain)
                        }
                        .toolbar {
                            ToolbarItem(placement: .navigationBarTrailing) {
                                EditButton()
                                    .foregroundStyle(Color.gray)
                            }
                        }
                        .navigationTitle("Shopping Log")
                        .navigationBarTitleDisplayMode(.inline)
                        .font(.headline)
                    }
                    .searchable(text: $searchQuery, prompt: "Search for Logs")
                    // タブ1
                    .tabItem {
                        Image(systemName: "cart")
                        Text("Logs List")
                    }
                    .tag(0)
                    // Settings Tab
                    SettingView()
                        .tabItem {
                            Image(systemName: "gearshape")
                            Text("Settings")
                        }
                        .tag(1)
                }
                .accentColor(.white)
            }
            // 丸い追加ボタン
            HStack {
                VStack(alignment: .trailing) {
                    Spacer() // 右端にスペースを追加
                    Button(action: {
                        showCreateLogView = true
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .foregroundColor(.green)
                    }
                    .padding(3)
                    //                        .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .zIndex(1) // ボタンを最前面に表示
                    Spacer()
                        .frame(height: 25)
                }
            }
        }
        .fullScreenCover(isPresented: $showCreateLogView) {
            NavigationStack {
                CreateLogView()
            }
        }


    }
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
    struct AlbumItemView: View {
        let item: Item
//        let screenWidth: CGFloat

        var body: some View {
                if let selectedPhotoData = item.image,
                   let uiImage = UIImage(data: selectedPhotoData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity, maxHeight: 70)
                        .clipped()
                }
            }
        }
}

#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
