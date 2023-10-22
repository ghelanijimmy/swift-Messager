//
//  StartChat.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-21.
//

import Foundation
import Firebase

// MARK: - START CHAT
func startChat(with user1: User, and user2: User) -> String {
    let chatRoomId = chatRoomIdFrom(user1Id: user1.id, user2Id: user2.id)
    
    createRecentChat(in: chatRoomId, with: [user1, user2])
    
    return chatRoomId
}

// MARK: - CREATE RECENT CHAT ITEMS
func createRecentChat(in chatRoomId: String, with users: [User]) {
    var memberIdsToCreateRecent = [users.first!.id, users.last!.id]
    // does user have recent?
    FirebaseReference(for: .Recent).whereField(CHATROOMID, isEqualTo: chatRoomId).getDocuments { snapshot, eror in
        guard let snapshot = snapshot else {
            return
        }
        
        if !snapshot.isEmpty {
            memberIdsToCreateRecent = removeMemberWhoHasRecent(snapshot: snapshot, memberIds: memberIdsToCreateRecent)
        }
        
        for userId in memberIdsToCreateRecent {
            let senderUser = userId == User.currentId ? User.currentUser! : getReceiverFrom(users: users)
            let receiverUser = userId == User.currentId ? getReceiverFrom(users: users) : User.currentUser!
            
            let recentObject = RecentChat(chatRoomId: chatRoomId, senderId: senderUser.id, senderName: senderUser.username, receiverId: receiverUser.id, receiverName: receiverUser.username, memberIds: [senderUser.id, receiverUser.id], lastMessage: "", unreadCounter: 0, avatarLink: receiverUser.avatarLink)
            
            FirebaseRecentListener.shared.addRecent(recentObject)
        }
    }
}

// MARK: - REMOVE MEMBER WHO HAS RECENT
func removeMemberWhoHasRecent(snapshot: QuerySnapshot, memberIds: [String]) -> [String] {
    var memberIdsToCreateRecent = memberIds
    
    for recentData in snapshot.documents {
        do {
            let currentRecent = try recentData.data(as: RecentChat.self)
            let currentUserId = currentRecent.senderId
            
            if memberIdsToCreateRecent.contains(currentUserId) {
                memberIdsToCreateRecent.remove(at: memberIdsToCreateRecent.firstIndex(of: currentUserId)!)
            }
            
        } catch {
            print("Couldn't decode data ", error.localizedDescription)
        }
    }
    
    return memberIdsToCreateRecent
}

// MARK: - GET CHAT ROOM ID
func chatRoomIdFrom(user1Id: String, user2Id: String) -> String {
    var chatRoomId = ""
    
    let value = user1Id.compare(user2Id).rawValue
    
    chatRoomId = value < 0 ? (user1Id + user2Id) : (user2Id + user1Id)
    
    return chatRoomId
}

// MARK: - GET RECEIVER FROM
func getReceiverFrom(users: [User]) -> User {
    var allUsers = users
    
    allUsers.remove(at: allUsers.firstIndex(of: User.currentUser!)!)
    return allUsers.first!
}
