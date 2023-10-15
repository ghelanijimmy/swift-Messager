//
//  MessagesListView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-14.
//

import SwiftUI

struct MessagesListView: View {
    var body: some View {
        TabView {
            Text("Chat")
                .tabItem {
                    Label("Chat", systemImage: "message")
                }
            
            Text("List")
                .tabItem {
                    Label("List", systemImage: "quote.bubble")
                }
            
            Text("Users")
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
