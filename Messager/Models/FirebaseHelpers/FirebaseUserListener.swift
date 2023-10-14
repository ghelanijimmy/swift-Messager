//
//  FirebaseUserLIstener.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-13.
//

import Foundation
import Firebase

class FirebaseUserListener {
    static let shared = FirebaseUserListener()
    
    private init() {}
    
    // MARK: - LOGIN
    func loginUserWithEmail(email: String, password: String, completion: @escaping (_ error: Error?, _ isEmailVerified: Bool) -> Void) -> Void {
        Auth.auth().signIn(withEmail: email, password: password) { authDataResult, error in
            
            if error == nil {
                if let authDataResult = authDataResult {
                    if authDataResult.user.isEmailVerified {
                        
                        FirebaseUserListener.shared.downloadUserFromFirebase(userId: authDataResult.user.uid, email: email)
                        
                        completion(error, true)
                    } else {
                        print("Email is not verified ")
                        completion(error, false)
                    }
                }
            }
        }
    }
    
    
    // MARK: - REGISTER
    func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authDataResult, error in
            completion(error)
            
            if error == nil {
                
                if let authDataResult = authDataResult{
                    
                    //send verificaiton email
                    authDataResult.user.sendEmailVerification { error in
                        print("auth emaail sent with error: ", error?.localizedDescription ?? "")
                    }
                    
                    //create user and save it
                    let user = self.createUser(user: authDataResult.user, email: email)
                    
                    saveUserLocally(user)
                    self.saveUserToFirestore(user)
                }
            }
        }
    }
    
    // MARK: - CREATE USER OBJECT
    func createUser(user: Firebase.User, email: String) -> User {
        let user = User(id: user.uid, username: email, email: email, pushId: "", avatarLink: "",  status: "Hey there I'm using Messager")
        
        return user
    }
    
    // MARK: - RESET PASSWORD
    func resetPassword(email: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            completion(error)
        }
    }
    
    // MARK: - RESEND LINK METHODS
    func resendVerificationEmail(email: String, completion: @escaping (_ error: Error?) -> Void) {
        Auth.auth().currentUser?.reload(completion: { error in
            Auth.auth().currentUser?.sendEmailVerification(completion: { error in
                completion(error)
            })
        })
    }
    
    // MARK: - SAVE USERS
    func saveUserToFirestore(_ user: User) {
        do {
            try FirebaseReference(for: .User).document(user.id).setData(from: user)
        } catch {
            print("couldn't save to firestore ", error.localizedDescription)
        }
    }
    
    // MARK: - DOWNLOAD USER FROM FIREBASE
    func downloadUserFromFirebase(userId: String, email: String? = nil) {
        FirebaseReference(for: .User).document(userId).getDocument { querySnapshot, error in
            guard let document = querySnapshot else {
                print("No document for user")
                return
            }
            
            let result = Result {
                try? document.data(as: User.self)
            }
            
            switch result {
            case .success(let userObject):
                if let user = userObject {
                    saveUserLocally(user)
                } else {
                    print("Document does not exist")
                }
            case .failure(let error):
                print("Error decoding user ", error.localizedDescription)
            }
        }
    }
}
