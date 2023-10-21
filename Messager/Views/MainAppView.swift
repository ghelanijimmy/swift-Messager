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

struct MainAppView: View {
    // MARK: - PROPERTIES
    @State private var selection: TabSelection = .chat
    
    // MARK: - BODY
    var body: some View {
        TabView(selection: $selection) {
            ChatsListView()
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
                .tag(TabSelection.chat)
            
            Text("List")
                .tabItem {
                    Label("List", systemImage: "quote.bubble")
                }
                .tag(TabSelection.list)
            
            UsersListView()
                .tabItem {
                    Label("Users", systemImage: "person.2")
                }
                .tag(TabSelection.users)
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(TabSelection.settings)
        } //: TABVIEW
    }
}

#Preview {
    MainAppView()
}
