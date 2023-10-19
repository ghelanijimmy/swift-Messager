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

struct User: Codable, Equatable, Identifiable {
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
    
    // MARK: - SAVE TO USER DEFAULTS
    static func saveUserLocally(_ user: User) {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(user)
            UserDefaults.standard.set(data, forKey: CURRENTUSER)
        } catch {
            print("Error saving user locally ", error.localizedDescription)
        }
    }
    
    // MARK: - GET LOCAL USER
    static func getLocalImage(imageUrl: String, completion: @escaping (_ image: Image?) -> Void) {
        let storage = FireStorage()
        if imageUrl != "" {
            storage.downloadImage(imageUrl: imageUrl) { image in
                completion(image)
            }
        }
    }
    
    // MARK: - CREATE DUMMY USERS
    static private func createDummyUsers() {
        let names = [
            "Alison Stamp",
            "Inayah Duggan",
            "Alfie Thornton",
            "Rachelle Neale",
            "Anya Gates",
            "Juanity Bate"
        ]
        
        var imageIndex = 1
        var userIndex = 1
        
        for i in 0..<5 {
            let id = UUID().uuidString
            let fileDirectory = "Avatars/_\(id).jpg"
            FireStorage().uploadImage(UIImage(named: "user\(imageIndex)")!.jpegData(compressionQuality: 1)!, directory: fileDirectory) { documentLink in
                let user = User(id: id, username: names[i], email: "user\(userIndex)@mail.com", avatarLink: documentLink ?? "", status: "")
                userIndex += 1
                
                FirebaseUserListener.shared.saveUserToFirestore(user)
            }
            imageIndex += 1
            if imageIndex == 5 {
                imageIndex = 1
            }
        }
        
    }
}


