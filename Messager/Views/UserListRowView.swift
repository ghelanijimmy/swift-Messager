//
//  UserListRowView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-19.
//

import SwiftUI

struct UserListRowView: View {
    // MARK: - PROPERTIES
    @State var avatarLink: String = "avatar"
    @State var username: String = ""
    @State var status: String = ""
    @State var LocalImage: Image?
    
    // MARK: - FUNCTIONS
    func configure(user: User) {
        username = user.username
        status = user.status
        avatarLink = user.avatarLink
    }
    
    // MARK: - BODY
    var body: some View {
        VStack {
            List {
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

            } //: LIST
            .listStyle(.plain)
        } //: VSTACK
    }
}

#Preview {
    UserListRowView()
}
