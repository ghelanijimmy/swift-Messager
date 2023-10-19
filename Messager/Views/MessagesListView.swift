//
//  MessagesListView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-14.
//

import SwiftUI

enum TabSelection: String, Identifiable, CaseIterable {
    case chat = "Chat"
    case list = "List"
    case users = "Users"
    case settings = "Settings"
    
    var id: Self {
        self
    }
}

struct MessagesListView: View {
    // MARK: - PROPERTIES
    @State private var selection: TabSelection = .chat
    
    // MARK: - BODY
    var body: some View {
        TabView(selection: $selection) {
            Text("Chat")
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
            
            Text("List")
                .tabItem {
                    Label("List", systemImage: "quote.bubble")
                }
            
            UsersListView()
                .tabItem {
                    Label("Users", systemImage: "person.2")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        } //: TABVIEW
    }
}

#Preview {
    MessagesListView()
}
