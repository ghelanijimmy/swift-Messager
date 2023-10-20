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
    let avatarLink: String
    @State var LocalImage: Image?
    @State private var photos: PhotosPickerItem?
    @StateObject var storage = FireStorage()
    
    private let isEditing: Bool
    private let isSmall: Bool
    private let imageSize: CGFloat
    let saveUser: ((_ imageUrl: String) -> Void)?
    
    // MARK: - FUNCTIONS
    private func getLocalImage(imageUrl: String) {
        User.getLocalImage(imageUrl: imageUrl) { image in
            LocalImage = image
        }
    }
    
    init(avatarLink: String, isSmall: Bool? = false) {
        self.avatarLink = avatarLink
        self.isEditing = false
        self.saveUser = nil
        self.imageSize = isSmall == true ? 60 : 100
        self.isSmall = isSmall ?? false
    }
    
    init(avatarLink: String, saveUser: @escaping (_ imageLink: String) -> Void) {
        self.avatarLink = avatarLink
        self.isEditing = true
        self.saveUser = saveUser
        self.isSmall = false
        self.imageSize = 100
    }
    
    // MARK: - BODY
    var body: some View {
        Group {
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
                } //: ASYNC IMAGE
            } //: LOCAL IMAGE CONDITIONAL
        } //: GROUP
        .onAppear(perform: {
            getLocalImage(imageUrl: avatarLink)
        })
        if isEditing {
            VStack {
                PhotosPicker("Select a photo", selection: $photos, matching: .images)
                if storage.isUploading {
                    Text("\(String(storage.uploadProgress)) Percent")
                }
            } //: VSTACK
            .onChange(of: photos) {
                saveUser!("")
                photos?.loadTransferable(type: Data.self) { result in
                    switch result {
                    case .success(let data):
                        if let data = data {
                            if UIImage(data: data) != nil {
                                storage.uploadImage(data, directory: "Avatars/_\(User.currentId).jpg") { imageUrl in
                                    DispatchQueue.main.async {
                                        if let imageUrl = imageUrl {
                                            saveUser!(imageUrl)
                                            storage.saveFileLocally(fileData: data, fileName: User.currentId)
                                            getLocalImage(imageUrl: imageUrl)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    default :
                        saveUser!(avatarLink)
                    }
                }
            } //: ON CHANGE PHOTO PICKER
        } //: IS EDITING CONDITIONAL
    }
}

#Preview {
    ProfileImageView(avatarLink: User.currentUser?.avatarLink ?? "avatar")
}

#Preview("Is Editing") {
    ProfileImageView(avatarLink: User.currentUser?.avatarLink ?? "avatar") { imageUrl in
        
    }
}
