//
//  UserListRowView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-19.
//

import SwiftUI

struct UserListRowView: View {
    // MARK: - PROPERTIES
    @State var avatarLink: String
    @State var username: String
    @State var status: String
    @State var LocalImage: Image?
    
    init(user: User) {
        self.avatarLink = user.avatarLink
        self.username = user.username
        self.status = user.status
        self.LocalImage = nil
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationLink {
            Text("HI")
        } label: {
            HStack(alignment: .center) {
                ProfileImageView(avatarLink: $avatarLink, isSmall: true)
                    .padding(4)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(username)
                        .font(.caption)
                    
                    Text(status)
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
