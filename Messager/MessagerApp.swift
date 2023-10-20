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
            MainView(isLoggedIn: $isLoggedIn)
                .onAppear(perform: {
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
                })
        }
    }
}
