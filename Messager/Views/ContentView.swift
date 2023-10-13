//
//  ContentView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-11.
//

import SwiftUI

enum FocusType: CaseIterable, Hashable {
    case email
    case password
    case repeatPassword
}

struct ContentView: View {
    // MARK: - PROPERTIES
    @FocusState private var isFocused: FocusType?
    
    @StateObject var loginController: LoginController = LoginController()
    
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
                
                if loginController.hasError {
                    VStack {
                        Text(loginController.errorText)
                            .foregroundStyle(.red)
                    }
                }
                
                if loginController.isLoginView {
                    HStack{
                        Button(action: {
                            loginController.forgotPassword()
                        }){
                            Text("Forgot Password?")
                        }
                        Spacer()
                        Button(action: {
                            loginController.resendEmail()
                        }) {
                            Text("Resend Email")
                        }
                    } //: HSTACK
                    .padding()
                    .foregroundStyle(.black)
                }
            } //: GROUP
            
            
            Spacer()
            
            Button(action: {
                loginController.handleLoginSignup()
            }, label: {
                Text(loginSignupText.uppercased())
            })
            .padding()
            .padding(.horizontal, 30)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: .black.opacity(0.45), radius: 15, x: 0, y: 8)
            .foregroundStyle(.white)
            .padding()
            
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
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button(action: {
                    isFocused = nil
                }, label: {
                    Text("Done")
                })
            }
        } //: TOOLBAR
    } //: BODY
}

#Preview {
    ContentView()
}
