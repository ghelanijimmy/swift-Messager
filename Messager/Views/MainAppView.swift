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

class AppNavigation: ObservableObject {
    @Published var selection: TabSelection = .chat
    @Published var startChat: Bool = false
    @Published var chatRoomPath = NavigationPath()
    @Published var selectedChat: RecentChat?
    
    func changeTab(to tab: TabSelection) {
        selection = tab
    }
    
    func changeTab(to tab: TabSelection, forChatId: () -> String) {
        self.changeTab(to: tab)
        startChat = selection == .chat
        updateChatRoomId(with: forChatId())
    }
    
    func updateChatRoomId(with id: String) {
        FirebaseRecentListener.shared.downloadChat(with: id) { chat in
            self.selectedChat = chat
            self.chatRoomPath.append(chat)
        }
    }
}

struct MainAppView: View {
    // MARK: - PROPERTIES
    @State private var selection: TabSelection = .chat
    @StateObject var appNavigation = AppNavigation()
    
    // MARK: - BODY
    var body: some View {
        TabView(selection: $appNavigation.selection) {
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
        .environmentObject(appNavigation)
    }
}

#Preview {
    MainAppView()
}
