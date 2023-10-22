//
//  ChatsListView.swift
//  Messager
//
//  Created by Jimmy Ghelani on 2023-10-20.
//

import SwiftUI

struct ChatsListView: View {
    // MARK: - PROPERTIES
    @EnvironmentObject var appNavigation: AppNavigation
    @State var recentChats: [RecentChat] = []
    @State var searchText: String = ""
    @State var filteredRecentChats: [RecentChat] = []
    
    // MARK: - FUNCTIONS
    private func downloadRecentChats() {
        FirebaseRecentListener.shared.downloadAllRecentChats { allUsers in
            DispatchQueue.main.async {
                self.recentChats = allUsers
                self.filteredRecentChats = allUsers
            }
        }
    }
    
    private func deleteChat(with id: String) {
        recentChats.removeAll { chat in
            chat.id == id
        }
        
        filteredRecentChats.removeAll { chat in
            chat.id == id
        }
    }
    
    // MARK: - BODY
    var body: some View {
        NavigationStack(path: $appNavigation.chatRoomPath) {
            List {
                ForEach(filteredRecentChats) { chat in
                    NavigationLink(value: chat) {
                        ChatListRowItemView(recentUser: chat)
                    }
                }
                .onDelete(perform: { indexSet in
                    FirebaseRecentListener.shared.deleteRecent(searchText.isEmpty ? recentChats[indexSet.first!] : filteredRecentChats[indexSet.first!])
                    let chatList = searchText.isEmpty ? recentChats : filteredRecentChats
                    let chat = chatList[indexSet.first!]
                    let chatId = chat.id
                    deleteChat(with: chatId)
                })
            }
            .listStyle(.plain)
            .refreshable {
                downloadRecentChats()
            }
            .searchable(text: $searchText)
            .onChange(of: searchText) { oldValue, newValue in
                filteredRecentChats = newValue.isEmpty
                ? recentChats
                : recentChats.filter({ chat in
                    chat.receiverName.lowercased().contains(newValue.lowercased())
                })
            }
            .onAppear {
                downloadRecentChats()
            }
            .navigationDestination(for: RecentChat.self) { chat in
                VStack {
                    Text(chat.senderName)
                        .navigationBarBackButtonHidden()
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Button {
                                    appNavigation.chatRoomPath.removeLast(appNavigation.chatRoomPath.count)
                                } label: {
                                    Image(systemName: "chevron.left.circle")
                                }
                            }
                        }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Image(systemName: "square.and.pencil")
                        .resizable()
                        .foregroundStyle(.blue)
                        .onTapGesture {
                            appNavigation.changeTab(to: .users)
                        }
                }
            }
        }
    }
}

#Preview {
    ChatsListView()
        .environmentObject(AppNavigation())
}
