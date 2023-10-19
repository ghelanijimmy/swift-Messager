//
//  UserDetailView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-19.
//

import SwiftUI

struct UserDetailView: View {
    // MARK: - PROPERTIES
    @State var user: User
    // MARK: - BODY
    var body: some View {
        VStack {
            ProfileImageView(avatarLink: $user.avatarLink)
                .padding(10)
            
            HStack {
                Spacer()
                VStack {
                    Text(user.status.isEmpty ? "status" : user.status)
                        .foregroundStyle(user.status.isEmpty ? .gray : .blue)
                        .padding(.bottom, 20)
                    
                    Button(action: {}, label: {
                        Text("Start Chat")
                    })
                } //: VSTACK
                Spacer()
            }
            Spacer()
        } //: VSTACK
        .navigationTitle(user.username)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        UserDetailView(user: User(username: "username", email: "", status: "Available"))
    }
}
