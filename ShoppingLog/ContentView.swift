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
        NavigationStack {
            ZStack {
                VStack {
                    TabView(selection: $selectedTab) {
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
                        // タブ1
                        .tabItem {
                            Image(systemName: "cart.fill")
                            Text("Logs List")
                        }
                        .tag(0)

                        // Calendar Tab
                        Text("ここにタブ2のコンテンツを追加してください。")
                            .tabItem {
                                Image(systemName: "calendar")
                                Text("Calendar")
                            }
                            .tag(1)
                    }
                } // VStack
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                            .foregroundStyle(Color.gray)
                    }
                    ToolbarItem {
                        Button(action: {}) {
                            Label("Add Item", systemImage: "gearshape.fill")
                        }
                        .foregroundColor(.gray)
                    }
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
                                .frame(width: 60, height: 60)
                                .foregroundColor(.black)
                        }
                        .padding(3)
                        .background(Color.white)
                        .clipShape(Circle())
                        .shadow(radius: 10)
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
            .navigationTitle("Shopping Logs")
            .navigationBarTitleDisplayMode(.inline)
            .font(.headline)

        }
        .searchable(text: $searchQuery, prompt: "Search for Logs")

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
