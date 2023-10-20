//
//  SettingsView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-15.
//

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    // MARK: - PROPERTIES
    @State private var username: String = ""
    @State private var avatarLink: String = ""
    @State private var status: String = StatusOptions.Available.rawValue
    @State private var appVersion: String = "App Version"
    @State private var errorText: String = ""
    @State private var LocalImage: Image?
    
    // MARK: - FUNCTIONS
    private func showUserInfo() {
        if let user = User.currentUser {
            username = user.username
            status = user.status.isEmpty ? StatusOptions.Available.rawValue : user.status
            appVersion = "App version \(String(describing: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String))"
            avatarLink = user.avatarLink
        } else {
            username = "username"
            status = StatusOptions.Available.rawValue
            avatarLink = ""
            appVersion = "App Version"
        }
    }
    
    func saveUser() {
        if var user = User.currentUser {
            user.username = username
            user.status = status
            user.avatarLink = avatarLink
            User.saveUserLocally(user)
            FirebaseUserListener.shared.saveUserToFirestore(user)
        }
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List {
                // MARK: - USER SECTION
                Section {
                    NavigationLink(destination: {
                        ProfileSettignsView(username: $username, status: $status, avatarLink: $avatarLink, saveUser: saveUser)
                    }) {
                        HStack(alignment: .center) {
                            ProfileImageView(avatarLink: avatarLink)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text(username)
                                    .font(.caption)
                                
                                Text(status)
                                    .foregroundStyle(.secondary)
                                    .font(.footnote)
                            } //: VSTACK
                            
                            Spacer()
                        }
                    } //: HSTACK
                } //: SECTION
                .listRowBackground(Color.listItem)
                .headerProminence(.increased)
                
                // MARK: - SECTION 2
                Section {
                    VStack(spacing: 20) {
                        NavigationLink("Tell a Friend") {
                            Text("Tell a friend")
                        }
                        
                        NavigationLink("Terms and Conditions") {
                            Text("Terms and Conditions")
                        }
                    } //: VSTACK
                    .foregroundStyle(.blue)
                } //: SECTION
                .listRowBackground(Color.listItem)
                .headerProminence(.increased)
                
                // MARK: - LOGOUT SECTION
                Section {
                    VStack(alignment: .center) {
                        Text(appVersion)
                            .padding(5)
                        Divider()
                        Button(action: {
                            FirebaseUserListener.shared.logoutUser { error in
                                if error == nil {
                                    self.showUserInfo()
                                    self.errorText = ""
                                } else {
                                    self.errorText = "Error logging out"
                                }
                            }
                        }, label: {
                            HStack{
                                Spacer()
                                Text("Logout")
                                    .foregroundStyle(.red)
                                Spacer()
                            }
                        }) //: BUTTON
                        .padding(5)
                    } //: HSTACK
                } //: SECTION
                .listRowBackground(Color.listItem)
                .headerProminence(.increased)
                if !errorText.isEmpty {
                    HStack(alignment: .center) {
                        Spacer()
                        Text(errorText)
                            .foregroundStyle(.red)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }
                }
            } //: LIST
            .background(.listBackground)
            .scrollContentBackground(.hidden)
            .navigationTitle("Settings")
            .onAppear {
                showUserInfo()
            }
        } //: NAVIGATION STACK
    }
}

#Preview {
    TabView {
        SettingsView()
            .tabItem {
                Label("Settings", systemImage: "gear")
            }
    }
}
