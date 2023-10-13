//
//  LoginController.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-12.
//

import Foundation
import SwiftUI

class LoginController: ObservableObject {
    // MARK: - PROPERTIES
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var repeatPassword: String = ""
    @Published var isLoginView: Bool = true
    @Published var hasError: Bool = false
    @Published var errorText: String = ""
    
    // MARK: - FUNCTIONS
    func login() {
        withAnimation(.easeInOut){
            hasError = email.isEmpty || password.isEmpty
            errorText = "Email and Password fields are required"
        }
    }
    
    func signUp() {
        withAnimation(.easeInOut){
            hasError = email.isEmpty || password.isEmpty || repeatPassword.isEmpty
            errorText = "Email and both Password fields are required"
        }
    }
    
    func forgotPassword() {
        withAnimation(.easeInOut) {
            hasError = email.isEmpty
            errorText = "Email field is required"
        }
    }
    
    func resendEmail() {
        withAnimation(.easeInOut) {
            hasError = email.isEmpty
            errorText = "Email field is required"
        }
    }
    
    func updateUI() {
        withAnimation(.linear(duration: 0.15)) {
            hasError = false
            errorText = ""
            isLoginView.toggle()
        }
    }
    
    func handleLoginSignup() {
        if isLoginView {
            login()
        } else {
            signUp()
        }
    }
}
