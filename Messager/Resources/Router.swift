//
//  Router.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-14.
//

import Foundation
import SwiftUI

class Router: ObservableObject {
    public enum Destination: Codable, Hashable {
        case messagesList
        case messagesDetail
        case loginSignupView
        
        @ViewBuilder func view(from path: Binding<NavigationPath>) -> some View {
            switch self {
            case .messagesList:
                MessagesListView()
                    .toolbar(.hidden, for: .navigationBar)
            case .messagesDetail:
                EmptyView()
            case .loginSignupView:
                LoginSignupView(isLoggedIn: .constant(false))
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
    
    @Published var navPath = NavigationPath()
    
    func navigate(to destination: Destination) {
        navPath.append(destination)
    }
    
    func navigateBack() {
        navPath.removeLast()
    }
    
    func navigateToRoot() {
        navPath.removeLast(navPath.count)
    }
}
