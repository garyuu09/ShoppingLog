//
//  CreateLogView.swift
//  ShoppingLog
//
//  Created by Ryuga on 2023/10/27.
//

import SwiftUI
import SwiftData
import PhotosUI

struct CreateLogView: View {

        @Environment(\.modelContext) var modelContext
        @Environment(\.dismiss) var dismiss

        @State var item = Item()
        @State var selectedPhoto: PhotosPickerItem?

        var body: some View {
            List {
                Section("Info") {
                    TextField("Title", text: $item.title)
                    TextField("Location", text: $item.location)

                    DatePicker("Date", selection: $item.timestamp)
                        .fixedSize()
                }
                
                Section("Image") {
                    if let selectedPhotoData = item.image,
                       let uiImage = UIImage(data: selectedPhotoData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: .infinity, maxHeight: 300)
                    }
                    
                    PhotosPicker(selection: $selectedPhoto,
                                 matching: .images,
                                 photoLibrary: .shared()) {
                        Label("Add Image", systemImage: "photo")
                    }
                    
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
                }
            }

            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .primaryAction) {
                    Button("Add") {
                        save()
                        dismiss()
                    }
                    .accentColor(.green)
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

    private extension CreateLogView {

        func save() {
            modelContext.insert(item)
        }
    }
#Preview {
    CreateLogView()
}

