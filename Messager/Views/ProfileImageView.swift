//
//  ProfileImageView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-19.
//

import SwiftUI
import PhotosUI

struct ProfileImageView: View {
    // MARK: - PROPERTIES
    @Binding var avatarLink: String
    @Binding var LocalImage: Image?
    let isEditing: Bool
    
    @State private var photos: PhotosPickerItem?
    @ObservedObject var storage = FireStorage()
    
    private let isSmall: Bool
    private let imageSize: CGFloat
    
    
    let saveUser: ((_ imageUrl: String) -> Void)?
    
    init(avatarLink: Binding<String>) {
        self._avatarLink = avatarLink
        self._LocalImage = .constant(nil)
        self.isEditing = false
        self.saveUser = nil
        self.isSmall = true
        self.imageSize = 60
    }
    
    init(avatarLink: Binding<String>, LocalImage: Binding<Image?>) {
        self._avatarLink = avatarLink
        self._LocalImage = LocalImage
        self.isEditing = false
        self.saveUser = nil
        self.isSmall = false
        self.imageSize = 100
    }
    
    init(avatarLink: Binding<String>, LocalImage: Binding<Image?>, saveUser: @escaping (_ imageLink: String) -> Void) {
        self._avatarLink = avatarLink
        self._LocalImage = LocalImage
        self.isEditing = true
        self.saveUser = saveUser
        self.isSmall = false
        self.imageSize = 100
    }
    
    // MARK: - BODY
    var body: some View {
        if LocalImage != nil {
            LocalImage!
                .resizable()
                .scaledToFill()
                .clipShape(Circle())
                .frame(width: imageSize, height: imageSize)
                .padding(isSmall ? 0 : 16)
        } else{
            AsyncImage(url: URL(string: avatarLink)) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .clipShape(Circle())
                    .frame(width: imageSize, height: imageSize)
                    .padding(isSmall ? 0 : 16)
            } placeholder: {
                if isEditing && (storage.isUploading || avatarLink.isEmpty) {
                    ProgressView()
                        .frame(width: imageSize, height: imageSize)
                        .padding(isSmall ? 0 : 16)
                } else{
                    Image("avatar")
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                        .frame(width: imageSize, height: imageSize)
                        .padding(isSmall ? 0 : 16)
                }
            }
            if isEditing {
                VStack {
                    PhotosPicker("Select a photo", selection: $photos, matching: .images)
                    if storage.isUploading {
                        Text("\(String(storage.uploadProgress)) Percent")
                    }
                }
                .onChange(of: photos) {
                    photos?.loadTransferable(type: Data.self) { result in
                        switch result {
                        case .success(let data):
                            if let data = data {
                                if UIImage(data: data) != nil {
                                    storage.uploadImage(data, directory: "Avatars/_\(User.currentId).jpg") { imageUrl in
                                        DispatchQueue.main.async {
                                            if let imageUrl = imageUrl {
                                                self.avatarLink = imageUrl
                                                saveUser!(imageUrl)
                                                
                                                storage.saveFileLocally(fileData: data, fileName: User.currentId)
                                            }
                                        }
                                    }
                                }
                            }
                        default :
                            saveUser!(avatarLink)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileImageView(avatarLink: .constant(""), LocalImage: .constant(nil))
}
