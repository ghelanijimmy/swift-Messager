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
    @State private var username: String = "username"
    @State private var avatarLink: String = ""
    @State private var status: String = "status"
    @State private var appVersion: String = "App Version"
    @State private var errorText: String = ""
    
    // MARK: - FUNCTIONS
    private func showUserInfo() {
        if let user = User.currentUser {
            username = user.username
            status = user.status
            appVersion = "App version \(String(describing: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String))"
            
            if user.avatarLink != "" {
                avatarLink = user.avatarLink
            }
        } else {
            username = "username"
            status = "status"
            avatarLink = ""
            appVersion = "App Version"
        }
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List {
                // MARK: - USER SECTION
                Section {
                    HStack(alignment: .center) {
                        AsyncImage(url: URL(string: avatarLink)) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .padding(16)
                        } placeholder: {
                            Image("avatar")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 60, height: 60)
                                .padding(16)
                        }
                        
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Text(username)
                            
                            Text(status)
                                .foregroundStyle(.secondary)
                        } //: VSTACK
                        
                        Spacer()
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
        } //: NAVIGATION STACK
        .onAppear {
            showUserInfo()
        }
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
