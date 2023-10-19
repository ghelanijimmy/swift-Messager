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
    var filteredUsers: [User] {
        if searchText.isEmpty {
            return allUsers
        } else {
            return allUsers.filter {
                $0.username.lowercased().contains(searchText.lowercased())
            }
        }
    }
    @State var searchText: String = ""
    
    // MARK: - FUNCTIONS
    private func getUsers() {
        FirebaseUserListener.shared.downloadAllUsersFromFirebase { allUsers in
            DispatchQueue.main.async {
                self.allUsers = allUsers
            }
        }
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            List(filteredUsers) {user in
                UserListRowView(user: user)
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
    }
}

#Preview {
    UsersListView()
}
