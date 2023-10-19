//
//  UsersView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-18.
//

import SwiftUI

struct UsersView: View {
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    NavigationLink {
                        Text("HI")
                    } label: {
                        HStack(alignment: .center) {
                            ProfileImageView(avatarLink: .constant("avatar"))
                                .padding(4)
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("username")
                                    .font(.caption)
                                
                                Text("status")
                                    .foregroundStyle(.secondary)
                                    .font(.footnote)
                            } //: VSTACK
                            
                            Spacer()
                        }
                    }

                }
                .listStyle(.plain)
            }
            .navigationTitle("Users")
        } //: NAVIGATION STACK
    }
}

#Preview {
    UsersView()
}
