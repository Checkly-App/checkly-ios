//
//  chatViewModel.swift
//  messages
//
//  Created by Noura Alsulayfih on 08/07/1443 AH.
//

import Foundation
import Firebase


class chatViewModel: ObservableObject{
    
    @Published var chatText = ""
    @Published var count = 0
    @Published var chatMessages = [chatMessage]()
    
    let chatUser: Employee?
    let DB = Firestore.firestore()
    
    init(chatUser: Employee? ) {
        self.chatUser = chatUser
        fetchMessages()
    }
    
    func fetchMessages() {
        //change to current user
        let fromID = "111111111"
        guard let toID = chatUser?.id else { return }
        
        DB.collection("texts").document(fromID).collection(toID).order(by: "timestamp").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error)
                return
            }
            querySnapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let data = change.document.data()
                    let chatMessage = chatMessage(documentID: change.document.documentID, data: data)
                    self.chatMessages.append(chatMessage)
                }
            })
            DispatchQueue.main.async {
                self.count += 1
            }
        }
    }
    
    func handelSend() {
        //change to current user
        let fromID = "111111111"
        guard let toID = chatUser?.id else { return }

        let document = DB.collection("texts").document(fromID).collection(toID).document()
        
        let messageData = ["fromID" : fromID, "toID" : toID, "text" : self.chatText, "timestamp" : Timestamp() ] as [String : Any]
        
        document.setData(messageData) { error in
            if let error = error {
                return
            }
            
            self.persistRecentMessage()
            
            self.chatText = ""
            self.count += 1
        }
        
        let recipientMessageDocument = DB.collection("texts").document(toID).collection(fromID).document()
        
        recipientMessageDocument.setData(messageData) { error in
            if let error = error {
                return
            }
        }
        
    }
    
    
    private func persistRecentMessage() {
        
        guard let chatUser = chatUser else {
            return
        }

            //change to current user
        let userID = "111111111"
        guard let toID = self.chatUser?.id else { return }
                
        let data = [
            "timestamp": Timestamp(),
            "text": self.chatText,
            "fromID": userID,
            "toID": toID,
            "username": chatUser.name,
            "senderName": "Shahad Alshahrani", //change to current user
            "receiverName": chatUser.name,
            "photoURL": chatUser.photoURL
        ] as [String : Any]
        
        DB.collection("recent_messages").document(userID)
        .collection("messages")
        .document(toID)
        .setData(data) { error in
            if let error = error {
                print(error)
                return
            }
        }
        
        let data2 = [
            "timestamp": Timestamp(),
            "text": self.chatText,
            "fromID": userID,
            "toID": toID,
            "username": chatUser.name,
            "senderName": "Shahad Alshahrani",
            "receiverName": chatUser.name,
            "photoURL": "https://firebasestorage.googleapis.com:443/v0/b/checkly-292d2.appspot.com/o/VsWRopBPLQYNMXlL5u5mkcGETze2?alt=media&token=1c45e222-888c-49d5-a341-f45a17d59798"
        ] as [String : Any]
        
        DB.collection("recent_messages").document(toID)
        .collection("messages")
        .document(userID)
        .setData(data2) { error in
            if let error = error {
                print(error)
                return
            }
        }
    }
}




