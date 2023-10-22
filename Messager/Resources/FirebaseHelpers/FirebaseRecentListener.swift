//
//  FirebaseRecentListener.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-21.
//

import Foundation
import Firebase

class FirebaseRecentListener {
    static let shared = FirebaseRecentListener()
    
    private init() {}
    
    // MARK: - ADD RECENT
    func addRecent(_ recent: RecentChat) {
        do {
            try FirebaseReference(for: .Recent).document(recent.id).setData(from: recent)
        } catch {
            print("Couldn't save data ", error.localizedDescription)
        }
    }
    
    // MARK: - DOWNLOAD RECENT CHATS
    func downloadAllRecentChats(completion: @escaping (_ allUsers: [RecentChat]) -> Void) {
        FirebaseReference(for: .Recent).whereField(SENDERID, isEqualTo: User.currentId).addSnapshotListener({ querySnapshot, error in
            var recentChats: [RecentChat] = []
            guard let document = querySnapshot?.documents else {
                print("No chats found")
                return
            }
            
            let allChats = document.compactMap { (queryDocumentSnapshot) -> RecentChat? in
                return try? queryDocumentSnapshot.data(as: RecentChat.self)
            }
            
            for recent in allChats {
                if recent.lastMessage != "" {
                    recentChats.append(recent)
                }
            }
            
            recentChats.sort { lhs, rhs in
                lhs.date! > rhs.date!
            }
            
            completion(recentChats)
        })
    }
    
    // MARK: - DOWNLOAD SPECIFIC CHAT WITH ID
    func downloadChat(with id: String, completion: @escaping (_ chat: RecentChat) -> Void) {
        downloadAllRecentChats { allUsers in
            let chat = allUsers.first { recentChat in
                recentChat.chatRoomId == id
            }
            
            if let chat = chat {
                completion(chat)
            }
        }
    }
    
    // MARK: - DELETE CHAT
    func deleteRecent(_ recent: RecentChat) {
        FirebaseReference(for: .Recent).document(recent.id).delete()
    }
}
