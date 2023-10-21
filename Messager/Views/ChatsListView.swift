//
//  ChatsListView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-20.
//

import SwiftUI

struct ChatsListView: View {
    var body: some View {
        NavigationStack {
            List {
                ChatListRowItemView(recentUser: .tempChat)
            }
            .listStyle(.plain)
        }
    }
}

#Preview {
    ChatsListView()
}
