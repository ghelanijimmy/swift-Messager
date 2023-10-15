//
//  MessagerApp.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-11.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct MessagerApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @State var isLoggedIn: Bool = false
    
    var body: some Scene {
        WindowGroup {
            LoginSignupView(isLoggedIn: $isLoggedIn)
                .onAppear {
                    var handle: AuthStateDidChangeListenerHandle?
                    handle = Auth.auth().addStateDidChangeListener { auth, user in
                        Auth.auth().removeStateDidChangeListener(handle!)
                        if user != nil && userDefaults.object(forKey: CURRENTUSER) != nil {
                            DispatchQueue.main.async {
                                isLoggedIn = true
                            }
                        }
                    }
                }
        }
    }
}
