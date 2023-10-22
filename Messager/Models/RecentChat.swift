//
//  RecentChat.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-20.
//

import Foundation
import FirebaseFirestoreSwift

struct RecentChat: Codable, Identifiable, Hashable {
    var id = UUID().uuidString
    var chatRoomId = ""
    var senderId = ""
    var senderName = ""
    var receiverId = ""
    var receiverName = ""
    @ServerTimestamp var date = Date()
    var memberIds = [""]
    var lastMessage = ""
    var unreadCounter = 0
    var avatarLink = ""
    
    static let tempChat = RecentChat(id: "1", chatRoomId: "1", senderId: "1", receiverId: "2", receiverName: "receiver receiver", memberIds: ["1", "2"], lastMessage: "Hi there! This is a test message to see if you are getting this. I made it long to see how it looks", unreadCounter: 100, avatarLink: "avatar")
}
