//
//  EditLogView.swift
//  ShoppingLog
//
//  Created by Ryuga on 2023/10/27.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditLogView: View {

    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @Bindable var item: Item
    @State var selectedPhoto: PhotosPickerItem?

    var body: some View {
        NavigationStack {
            List {

                Section("To do title") {
                    TextField("Name", text: $item.title)
                }

                Section("Photo") {
                    if let selectedPhotoData = item.image,
                       let uiImage = UIImage(data: selectedPhotoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: 300)

                        if item.image != nil {

                            Button(role: .destructive) {
                                withAnimation {
                                    selectedPhoto = nil
                                    item.image = nil
                                }
                            } label: {
                                Label("Remove Image", systemImage: "xmark")
                                    .foregroundStyle(.red)
                            }
                        }
                        PhotosPicker(selection: $selectedPhoto,
                                     matching: .images,
                                     photoLibrary: .shared()) {
                            Label("Add Image", systemImage: "photo")
                        }
                    }
                }

                Section("General") {
                    DatePicker("Choose a date",
                               selection: $item.timestamp)
                }

                Section {
                    Button("Create") {
                        save()
                        dismiss()
                    }
                }
            }
        }

        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button("Done") {
                    save()
                    dismiss()
                }
                .disabled(item.title.isEmpty)
            }
        }
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                item.image = data
            }
        }
    }
}

private extension EditLogView {

    func save() {
        modelContext.insert(item)
    }
}