//
//  ProfileSettignsView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-17.
//

import SwiftUI
import PhotosUI

enum StatusOptions: String, CaseIterable, Identifiable {
    case Available = "Available"
    case Busy = "Busy"
    case AtSchool = "At School"
    case AtTheMoviews = "At The Movies"
    case AtWork = "At Work"
    case BatteryAboutToDie = "Battery About To Die"
    case CantTalk = "Can't Talk"
    case inAMeeting = "In A Meeting"
    case atTheGym = "At The Gym"
    case Sleeping = "Sleeping"
    case UrgentCallsOnly = "Urgent Calls Only"
    case Unavailable = "Unavailable"
    
    var id: Self {
        self
    }
}

struct ProfileSettignsView: View {
    // MARK: - PROPERTIES
    @Binding var username: String
    @FocusState var isEditingUsername: Bool
    @Binding var status: String
    @Binding var avatarLink: String
    @State var photos: PhotosPickerItem?
    @ObservedObject var storage = FireStorage()
    let saveUser: () -> Void
    @State private var LocalImage: Image?
    
    // MARK: - FUNCTIONS
    private func showUserInfo() {
        if let user = User.currentUser {
            username = user.username
            status = user.status
            
            if user.avatarLink != "" {
                avatarLink = user.avatarLink
                storage.downloadImage(imageUrl: user.avatarLink) { image in
                    if let image = image {
                        LocalImage = image
                    } else {
                        LocalImage = nil
                    }
                }
            }
        }
    }
    
    // MARK: - BODY
    var body: some View {
        VStack {
            List {
                Section {
                    HStack(alignment: .center) {
                        VStack {
                            ProfileImageView(avatarLink: $avatarLink, LocalImage: $LocalImage) { imageLink in
                                self.avatarLink = imageLink
                                saveUser()
                            }
                        }
                        
                        Text("Enter your name and add an optional profile picture")
                            .font(.system(size: 17))
                            .foregroundStyle(.gray)
                            .padding(.leading, 10)
                        
                        Spacer()
                    } //: HSTACK
                    .padding(.bottom, 20)
                    
                    TextField("username", text: $username)
                        .focused($isEditingUsername)
                        .showClearButton($username)
                        .onSubmit {
                            saveUser()
                            isEditingUsername = false
                        }
                } //: SECTION
                
                Section {
                    Picker("State", selection: $status) {
                        ForEach(StatusOptions.allCases) { s in
                            Text(s.rawValue)
                                .tag(s.rawValue)
                        }
                    }
                    .onChange(of: status) { oldValue, newValue in
                        saveUser()
                    }
                } //: SECTION
            } //: LIST
        } //: VSTACK
        .navigationTitle("Edit Profile")
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button("Done") {
                    isEditingUsername = false
                }
            }
        }
        .onAppear {
            showUserInfo()
        }
    }
}

#Preview {
//    var bindableIsVisibleError: Binding<String> { Binding(
//        get: { User.currentUser?.username ?? "username" },
//        set: { if !$0.isEmpty {
//            print($0)
//        }}
//        )
//    }
    return NavigationStack {
        @State var username = User.currentUser?.username ?? "username"
        @State var status = User.currentUser?.status ?? StatusOptions.Available.rawValue
        @State var avatarLink = User.currentUser?.avatarLink ?? ""
        var saveUser = {
            print("saved")
        }
        return ProfileSettignsView(username: $username, status: $status, avatarLink: $avatarLink, saveUser: saveUser)
    }
}
