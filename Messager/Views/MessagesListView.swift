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
            Text("Hello")
                .tabItem {
                    Label("Item", systemImage: "circle.fill")
                }
            
            Text("World")
                .tabItem {
                    Label("Item", systemImage: "circle.fill")
                }
        } //: TABVIEW
    }
}

#Preview {
    MessagesListView()
}
