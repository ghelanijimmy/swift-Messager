//
//  LoginSignupView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-17.
//

import SwiftUI

struct LoginSignupView: View {
    // MARK: - PROPERTIES
    @FocusState private var isFocused: FocusType?
    @StateObject var loginController: LoginController = LoginController()
    @State var actionButtonClicked: Bool = false
    let handleLogin: (_ isLoggedIn: Bool) -> Void
    
    enum FocusType: CaseIterable, Hashable {
        case email
        case password
        case repeatPassword
    }
    
    var loginSignupText: String {
        loginController.isLoginView ? "Login" : "Sign up"
    }
    
    var loginSignupSubText: String {
        loginController.isLoginView ? "Don't have an account?" : "Already have an account?"
    }
    
    // MARK: - BODY
    var body: some View {
        VStack {
            Text(loginSignupText)
                .font(.custom("Avenir Book", size: 35))
            
            Group {
                VStack {
                    TextField("Email", text: $loginController.email)
                        .modifier(LoginFieldsModifier())
                        .focused($isFocused, equals: .email)
                        .onChange(of: loginController.email, loginController.hideResendIfNoEmail)
                        .onTapGesture(perform: {
                            isFocused = .email
                        })
                    
                    TextField("Password", text: $loginController.password)
                        .modifier(LoginFieldsModifier())
                        .focused($isFocused, equals: .password)
                        .onTapGesture(perform: {
                            isFocused = .password
                        })
                    
                    if !loginController.isLoginView {
                        TextField("Repeat Password", text: $loginController.repeatPassword)
                            .modifier(LoginFieldsModifier())
                            .focused($isFocused, equals: .repeatPassword)
                    }
                    
                } //: VSTACK
                .padding()
                
                // MARK: - NOTIFICATION SECTION
                if loginController.notificationType != nil {
                    VStack {
                        Text(loginController.notificationType!.message)
                            .foregroundStyle(loginController.notificationType!.isErrorType ? .red : .white)
                            .padding()
                            .background(loginController.notificationType!.isErrorType ? .white : .gray)
                            .clipShape(RoundedRectangle(cornerRadius: 9))
                    }
                }
                
                // MARK: - FORGOT / RESEND
                if loginController.isLoginView {
                    HStack{
                        Button(action: {
                            loginController.forgotPassword()
                        }){
                            Text("Forgot Password?")
                        }
                        Spacer()
                        if !loginController.resendButtonHidden{
                            Button(action: {
                                loginController.resendEmail()
                            }) {
                                Text("Resend Email")
                            }
                        }
                    } //: HSTACK
                    .padding()
                    .foregroundStyle(.blue)
                }
            } //: GROUP
            
            
            Spacer()
            
            // MARK: - LOGIN SIGNUP BUTTON
            Button(action: {
                actionButtonClicked = true
                loginController.handleLoginSignup { notificationType in
                    DispatchQueue.main.async {
                        handleLogin(notificationType == nil ? true : false)
                        actionButtonClicked = false
                    }
                }
            }, label: {
                if(actionButtonClicked) {
                    ProgressView()
                } else {
                    Text(loginSignupText.uppercased())
                }
            })
            .padding()
            .padding(.horizontal, 30)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.45), radius: 15, x: 0, y: 8)
            .foregroundStyle(.white)
            .padding()
            .disabled(actionButtonClicked)
            
            Spacer()
            
            
            HStack {
                Text(loginSignupSubText)
                Button(action: {
                    loginController.updateUI()
                }) {
                    Text(loginController.isLoginView ? "Sign up" : "Login")
                }
            } //: HSTACK
            
            
            
        } //: VSTACK
        .contentShape(Rectangle())
        .onTapGesture(perform: {
            withAnimation(.linear) {
                isFocused = nil
            }
        })
        .toolbar() {
            ToolbarItem(placement: .keyboard) {
                Button(action: {
                    isFocused = nil
                }, label: {
                    Text("Done")
                })
            }
        } //: TOOLBAR
        .onAppear(perform: {
            loginController.resetUI()
        })
    }
}

#Preview {
    LoginSignupView() { _ in }
}
