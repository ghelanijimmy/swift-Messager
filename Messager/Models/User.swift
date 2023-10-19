//
//  User.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-13.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseFirestoreSwift
import FirebaseAuth

struct User: Codable, Equatable {
    var id = ""
    var username: String
    let email: String
    var pushId = ""
    var avatarLink = ""
    var status: String
    
    static var currentId: String {
        Auth.auth().currentUser!.uid
    }
    
    static var currentUser: User? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.data(forKey: CURRENTUSER) {
                let decoder = JSONDecoder()
                
                do {
                    let userObject = try decoder.decode(User.self, from: dictionary)
                    return userObject
                } catch {
                    print("Error decoding user from user defaults", error.localizedDescription)
                }
            }
        }
        
        return nil
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }
}


// MARK: - SAVE TO USER DEFAULTS

func saveUserLocally(_ user: User) {
    let encoder = JSONEncoder()
    do {
        let data = try encoder.encode(user)
        UserDefaults.standard.set(data, forKey: CURRENTUSER)
    } catch {
        print("Error saving user locally ", error.localizedDescription)
    }
}
