//
//  UserListRowView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-19.
//

import SwiftUI

struct UserListRowView: View {
    // MARK: - PROPERTIES
    @State var user: User
    
    // MARK: - BODY
    var body: some View {
        NavigationLink {
            UserDetailView(user: user)
        } label: {
            HStack(alignment: .center) {
                ProfileImageView(avatarLink: $user.avatarLink, isSmall: true)
                    .padding(4)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(user.username)
                        .font(.caption)
                    
                    Text(user.status)
                        .foregroundStyle(.secondary)
                        .font(.footnote)
                } //: VSTACK
                
                Spacer()
            } //: HSTACK
        } //: LABEL
    }
}

#Preview {
    NavigationStack {
        UserListRowView(user: User.currentUser ?? User(username: "", email: "", status: ""))
    }
}
