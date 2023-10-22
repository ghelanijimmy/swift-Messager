//
//  UserDetailView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-19.
//

import SwiftUI

struct UserDetailView: View {
    // MARK: - PROPERTIES
    let user: User
    @EnvironmentObject var appNavigation: AppNavigation
    // MARK: - BODY
    var body: some View {
        VStack {
            ProfileImageView(avatarLink: user.avatarLink)
                .padding(10)
            
            HStack {
                Spacer()
                VStack {
                    Text(user.status.isEmpty ? "status" : user.status)
                        .foregroundStyle(user.status.isEmpty ? .gray : .blue)
                        .padding(.bottom, 20)
                    
                    Button(action: {
                        appNavigation.changeTab(to: .chat) {
                            return startChat(with: User.currentUser!, and: user)
                        }
                    }, label: {
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
        UserDetailView(user: User.currentUser ?? User(username: "", email: "", status: ""))
            .environmentObject(AppNavigation())
    }
}
