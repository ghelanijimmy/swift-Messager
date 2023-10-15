//
//  ContentView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-11.
//

import SwiftUI
import FirebaseAuth

enum FocusType: CaseIterable, Hashable {
    case email
    case password
    case repeatPassword
}

struct LoginSignupView: View {
    // MARK: - PROPERTIES
    
    @FocusState private var isFocused: FocusType?
    @StateObject var loginController: LoginController = LoginController()
    @ObservedObject var router: Router = Router()
    @State var actionButtonClicked: Bool = false
    @Binding var isLoggedIn: Bool
    
    var loginSignupText: String {
        loginController.isLoginView ? "Login" : "Sign up"
    }
    
    var loginSignupSubText: String {
        loginController.isLoginView ? "Don't have an account?" : "Already have an account?"
    }
    
    // MARK: - BODY
    var body: some View {
        
        NavigationStack(path: $router.navPath) {
            if isLoggedIn {
                MessagesListView()
            } else {
                VStack {
                    Text(loginSignupText)
                        .font(.custom("Avenir Book", size: 35))
                    
                    Group {
                        VStack {
                            TextField("Email", text: $loginController.email)
                                .modifier(LoginFieldsModifier())
                                .focused($isFocused, equals: .email)
                                .onChange(of: loginController.email) {
                                    if loginController.email.isEmpty {
                                        loginController.resendButtonHidden = true
                                    }
                                }
                            
                            TextField("Password", text: $loginController.password)
                                .modifier(LoginFieldsModifier())
                                .focused($isFocused, equals: .password)
                            
                            if !loginController.isLoginView {
                                TextField("Repeat Password", text: $loginController.repeatPassword)
                                    .modifier(LoginFieldsModifier())
                                    .focused($isFocused, equals: .repeatPassword)
                            }
                            
                        } //: VSTACK
                        .padding()
                        
                        // MARK: - NOTIFICATION SECTION
                        if loginController.hasError || loginController.showNotificaiton {
                            VStack {
                                Text(loginController.hasError ? loginController.errorText : loginController.notificationMessage)
                                    .foregroundStyle(loginController.hasError ? .red : .blue)
                            }
                        }
                        
                        // MARK: - EMAIL VERIFICATION SENT
                        if loginController.verificationSent {
                            VStack {
                                Text("Verification email sent")
                                    .foregroundStyle(.white)
                            }
                            .padding()
                            .background(.blue)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
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
                        actionButtonClicked.toggle()
                        loginController.handleLoginSignup {
                            router.navigate(to: .messagesList)
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
                .navigationDestination(for: Router.Destination.self) { destination in
                    destination.view(from: $router.navPath)
                }
            }
        } //: NAVSTACK
    } //: BODY
}

#Preview {
    LoginSignupView(isLoggedIn: .constant(false))
}

#Preview("Logged In") {
    LoginSignupView(isLoggedIn: .constant(true))
}
