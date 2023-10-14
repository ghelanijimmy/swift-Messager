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
    @Published var verificationSent: Bool = false
    @Published var resendButtonHidden: Bool = true
    @Published var hasLoggedInSuccessfully: Bool = false
    @Published var showNotificaiton: Bool = false
    @Published var notificationMessage: String = ""
    
    // MARK: - FUNCTIONS
    func login() {
        withAnimation(.easeInOut){
            hasError = email.isEmpty || password.isEmpty
            errorText = "Email and Password fields are required"
        }
        
        if !hasError {
            FirebaseUserListener.shared.loginUserWithEmail(email: email, password: password) { error, isEmailVerified in
                
                if error == nil {
                    if isEmailVerified {
                        self.resendButtonHidden = true
                        // GO TO APP
                        self.goToApp()
                    } else {
                        self.hasError = true
                        self.errorText = "Please verify your eamil"
                        self.resendButtonHidden = true
                    }
                } else {
                    self.hasError = true
                    self.errorText = error?.localizedDescription ?? ""
                }
            }
        }
    }
    
    func signUp() {
        withAnimation(.easeInOut){
            hasError = email.isEmpty || password.isEmpty || repeatPassword.isEmpty
            errorText = "Email and both Password fields are required"
        }
        
        if !hasError {
            FirebaseUserListener.shared.registerUserWith(email: email, password: password) { error in
                if error == nil {
                    self.resetUI()
                } else {
                    print(error ?? "")
                }
            }
        }
    }
    
    // MARK: - NAVIGATE TO APP
    
    private func goToApp() {
        print("Go to app")
    }
    
    func forgotPassword() {
        withAnimation(.easeInOut) {
            hasError = email.isEmpty
            errorText = "Email field is required"
        }
        if !email.isEmpty {
            FirebaseUserListener.shared.resetPassword(email: email) { error in
                self.hasError = error != nil
                self.showNotificaiton = error == nil
                if self.hasError {
                    self.errorText = "Couldn't send reset password email"
                } else {
                    self.notificationMessage = "Reset password email sent"
                }
            }
        } else {
            self.hasError = true
            self.errorText = "Email field can't be empty"
        }
    }
    
    func resendEmail() {
        withAnimation(.easeInOut) {
            hasError = email.isEmpty
            errorText = "Email field is required"
        }
        
        if !email.isEmpty {
            FirebaseUserListener.shared.resendVerificationEmail(email: email) { error in
                self.hasError = error != nil
                self.showNotificaiton = error == nil
                if self.hasError {
                    self.errorText = "Couldn't send verification email"
                } else {
                    self.notificationMessage = "Verification email resent"
                }
            }
        } else {
            self.hasError = true
            self.errorText = "Email field can't be empty"
        }
    }
    
    func updateUI() {
        withAnimation(.linear(duration: 0.15)) {
            resetUI()
        }
    }
    
    func resetUI() {
        withAnimation(.linear(duration: 0.15)) {
            self.isLoginView.toggle()
            self.hasError = false
            self.errorText = ""
            self.email = ""
            self.password = ""
            self.repeatPassword = ""
            self.verificationSent = true
            self.resendButtonHidden = false
        }
    }
    
    func handleLoginSignup() {
        if isLoginView {
            login()
        } else {
            if password == repeatPassword {
                signUp()
            } else {
                hasError = true
                errorText = "Passwords do not match"
            }
        }
    }
}
