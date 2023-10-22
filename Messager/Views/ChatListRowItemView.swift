//
//  ChatListRowItemView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-20.
//

import SwiftUI

struct ChatListRowItemView: View {
    // MARK: - PROPERTIES
    let recentUser: RecentChat
    var unreadCounter: String {
        if recentUser.unreadCounter >= 100 {
            return String("\(99)+")
        } else {
            return String(recentUser.unreadCounter)
        }
    }
    
    var timeLabel: String {
        return timeElapsed(recentUser.date ?? Date())
    }
    
    // MARK: - BODY
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center, spacing: 20) {
                ProfileImageView(avatarLink: recentUser.avatarLink, isSmall: true)
                
                VStack(alignment: .leading, spacing: 10) {
                    HStack {
                        Text(recentUser.receiverName)
                            .font(.title2)
                            .frame(maxHeight: 30)
                            .minimumScaleFactor(0.3)
                        Spacer(minLength: 20)
                        Text(timeLabel)
                            .font(.footnote)
                    }
                    HStack {
                        Text(recentUser.lastMessage)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                        Spacer(minLength: 20)
                        if recentUser.unreadCounter != 0 {
                            Circle()
                                .fill(.red)
                                .frame(width: 30, height: 30, alignment: .center)
                                .overlay {
                                    Text(unreadCounter)
                                        .foregroundStyle(.white)
                                        .font(.caption)
                                } //: COUNT OVERLAY TEXT
                        } //: COUNT CONDITIONAL
                    } //: HSTACK
                } //: USER VSTACK
            } //: PROFILE HSTACK
        } //: BODY VSTACK
        .padding()
        .foregroundStyle(.black)
    }
}

#Preview {
    NavigationStack {
        List {
            ChatListRowItemView(recentUser: .tempChat)
        }
        .listStyle(.plain)
    }
}
