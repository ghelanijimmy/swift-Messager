//
//  UsersListView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-18.
//

import SwiftUI

struct UsersListView: View {
    // MARK: - PROPERTIES
    
    // MARK: - BODY
    var body: some View {
        NavigationStack {
            UserListRowView()
            .navigationTitle("Users")
        } //: NAVIGATION STACK
    }
}

#Preview {
    UsersListView()
}
