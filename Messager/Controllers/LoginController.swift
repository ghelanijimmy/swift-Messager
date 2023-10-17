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
    @Published var resendButtonHidden: Bool = true
    @Published var hasLoggedInSuccessfully: Bool = false
    @Published var notificationType: NotificationType?
    
    enum NotificationType: Equatable {
        case error(message: String)
        case notificaiton(message: String)
        
        var message: String {
            switch self {
            case .error(let message):
                return message
            case .notificaiton(let message):
                return message
            }
        }
        
        var isErrorType: Bool {
            switch self {
            case .error(_):
                return true
            case .notificaiton(_):
                return false
            }
        }
    }
    
    // MARK: - FUNCTIONS
    func login(completion: @escaping (_ notificationType: NotificationType?) -> Void) {
        withAnimation(.easeInOut){
            if email.isEmpty || password.isEmpty {
                notificationType = .error(message: "Email and Password fields are required")
            }
        }
        
        
        if notificationType == nil {
            FirebaseUserListener.shared.loginUserWithEmail(email: email, password: password) { error, isEmailVerified in
                
                if error != nil {
                    self.notificationType = .error(message: error?.localizedDescription ?? "")
                }
                
                if !isEmailVerified {
                    self.showVerificationMessage()
                } else {
                    self.notificationType = nil
                }
                
                completion(self.notificationType)
            }
        }
        
    }
    
    func signUp(completion: @escaping (_ notificationType: NotificationType?) -> Void) {
        withAnimation(.easeInOut){
            if email.isEmpty || password.isEmpty || repeatPassword.isEmpty {
                notificationType = .error(message: "Email and both Password fields are required")
            }
        }
        
        if notificationType == nil {
            FirebaseUserListener.shared.registerUserWith(email: email, password: password) { error in
                
                if error != nil {
                    self.notificationType = .error(message: error?.localizedDescription ?? "")
                } else {
                    self.notificationType = nil
                    self.isLoginView = true
                }
                
                completion(self.notificationType)
            }
        }
        
    }
    
    func showVerificationMessage() {
        resendButtonHidden = false
        notificationType = .notificaiton(message: "Pelase verify your email first before logging in")
    }
    
    func hideNotifications() {
        notificationType = nil
    }
    
    func forgotPassword() {
        if !email.isEmpty {
            FirebaseUserListener.shared.resetPassword(email: email) { error in
                if error != nil {
                    self.notificationType = .error(message: "Couldn't send reset password email")
                } else {
                    self.notificationType = .notificaiton(message: "Reset password email sent")
                }
            }
        } else {
            notificationType = .error(message: "Email can't be empty")
        }
    }
    
    func resendEmail() {
        if !email.isEmpty {
            FirebaseUserListener.shared.resendVerificationEmail(email: email) { error in
                if error != nil {
                    self.notificationType = .error(message: "Couldn't send verificatione email")
                } else {
                    self.notificationType = .notificaiton(message: "Verification email sent")
                }
            }
        } else {
            notificationType = .error(message: "Email field can't be empty")
        }
    }
    
    func updateUI() {
        withAnimation(.linear(duration: 0.15)) {
            isLoginView.toggle()
            notificationType = nil
            resendButtonHidden = true
        }
    }
    
    func hideResendIfNoEmail() {
        if email.isEmpty {
            resendButtonHidden = true
        }
        notificationType = nil
    }
    
    func resetUI() {
        withAnimation(.linear(duration: 0.15)) {
            self.isLoginView = true
            self.notificationType = nil
            self.email = ""
            self.password = ""
            self.repeatPassword = ""
            self.resendButtonHidden = true
        }
    }
    
    func handleLoginSignup(completion: @escaping (_ notificationType: NotificationType?) -> Void) {
        if isLoginView {
            login(completion: completion)
        } else {
            if password == repeatPassword {
                signUp(completion: completion)
            } else {
                notificationType = .error(message: "Passwords do not match")
            }
        }
    }
}
