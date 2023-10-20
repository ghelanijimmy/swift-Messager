//
//  ContentView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-11.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    // MARK: - PROPERTIES
    @Binding var isLoggedIn: Bool
    
    // MARK: - BODY
    var body: some View {
        Group {
            if isLoggedIn {
                MessagesListView()
            } else {
                LoginSignupView() { shouldLogin in
                    isLoggedIn = shouldLogin
                }
            } //: ELSE
        }
        
    } //: BODY
}

#Preview("Login screen") {
    MainView(isLoggedIn: .constant(false))
}

#Preview("Main App") {
    MainView(isLoggedIn: .constant(true))
}
