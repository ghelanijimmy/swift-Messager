//
//  UsersListView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-18.
//

import SwiftUI

struct UsersListView: View {
    // MARK: - PROPERTIES
    @State var allUsers: [User] = []
    @State var filtered: [User] = []
    @State var searchText: String = ""
    
    // MARK: - FUNCTIONS
    private func getUsers() {
        FirebaseUserListener.shared.downloadAllUsersFromFirebase { allUsers in
            DispatchQueue.main.async {
                self.allUsers = allUsers
                self.filtered = allUsers
            }
        }
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List($filtered) {$user in
                UserListRowView(user: $user)
                    .navigationTitle("Users")
            } //: LIST
            .listStyle(.plain)
            .onAppear(perform: {
                getUsers()
            })
            .refreshable {
                getUsers()
            }
        } //: NAVIGATION STACK
        .searchable(text: $searchText, prompt: "Search for user")
        .onChange(of: searchText) { _, nv in
            self.filtered = nv.isEmpty ? allUsers : allUsers.filter {
                $0.username.lowercased().contains(nv.lowercased())
            }
        }
    }
}

#Preview {
    UsersListView()
}
