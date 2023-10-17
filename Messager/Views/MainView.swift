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
    @State var isLoggedIn: Bool = false
    
    // MARK: - BODY
    var body: some View {
        Group {
            if isLoggedIn {
                MessagesListView()
            } else {
                LoginSignupView(isLoggedIn: $isLoggedIn)
            } //: ELSE
        }
        .onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil && userDefaults.object(forKey: CURRENTUSER) != nil {
                    DispatchQueue.main.async {
                        isLoggedIn = true
                    }
                } else {
                    DispatchQueue.main.async {
                        isLoggedIn = false
                    }
                }
            }
        }
        
    } //: BODY
}

#Preview("Login screen") {
    MainView()
}
