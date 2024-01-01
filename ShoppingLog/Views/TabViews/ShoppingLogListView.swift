//
//  ShoppingLogListView.swift
//  ShoppingLog
//
//  Created by Ryuga on 2023/11/05.
//

import SwiftUI
import SwiftData

struct ShoppingLogListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    @State private var showCreateLogView = false
    @State private var searchQuery = ""
    @State private var selectedSortOption = SortOption.allCases.first!

    var filteredItems: [Item] {

        if searchQuery.isEmpty {
            return items.sort(option: selectedSortOption)
        }

        let filteredItems = items.compactMap { item in

            let titleContainsQuery = item.title.range(of: searchQuery,
                                                      options: .caseInsensitive) != nil
            let locationContainsQuery = item.location.range(of: searchQuery,
                                                      options: .caseInsensitive) != nil

            return (titleContainsQuery || locationContainsQuery) ? item : nil
        }

        return filteredItems.sort(option: selectedSortOption)
    }

    var body: some View {
        ZStack {
            NavigationStack {
                VStack {
                    List {
                        ForEach(filteredItems) { item in
                            NavigationLink {
                                EditLogView(item: item)

                            } label: {
                                HStack(alignment: .top) {
                                    VStack(alignment: .leading, spacing: 2) {
                                        HStack {
                                            // 日付
                                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .none))
                                                .font(.caption2)
                                            // 場所
                                            Text("@\(item.location)")
                                        }

                                        // タイトル
                                        Text(item.title)
                                            .font(.subheadline)
                                            .foregroundColor(.white)

                                    }
                                    Spacer()
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
                        Menu {
                            Picker("", selection: $selectedSortOption) {
                                ForEach(SortOption.allCases,
                                        id: \.rawValue) { option in
                                    Label(option.rawValue.capitalized,
                                          systemImage: option.systemImage)
                                    .tag(option)
                                }
                            }
//                            .labelsHidden()
                        } label: {
                            Image(systemName: "line.horizontal.3.decrease.circle")
                        }
                    }
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
            // 丸い追加ボタン
            .safeAreaInset(edge: .bottom,
                           alignment: .trailing) {
                    Button {
                        showCreateLogView = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.green)
                    }
                    .padding(20)
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .zIndex(1) // ボタンを最前面に表示
            }
        }
        .overlay {
            if items.isEmpty {
                ContentUnavailableView(
                    "No Shopping Logs",
                    systemImage: "doc.richtext.fill",
                    description: Text("Try to search for another title.")
                )
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
}

struct AlbumItemView: View {
    let item: Item

    var body: some View {
        if let selectedPhotoData = item.image,
           let uiImage = UIImage(data: selectedPhotoData) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: 140, maxHeight: 70)
                .clipped()
        }
    }
}

extension [Item] {
    func sort(option: SortOption) -> [Item] {
        switch option {
        case .title:
            self.sorted(by: { $0.title < $1.title })
        case .date:
            self.sorted(by: { $0.timestamp < $1.timestamp })
        case .location:
            self.sorted(by: { $0.location < $1.location })
        }
    }
}

#Preview {
    ShoppingLogListView()
}
