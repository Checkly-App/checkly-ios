
import Foundation
import Firebase


class chatViewModel: ObservableObject{
    
    @Published var chatText = ""
    @Published var count = 0
    @Published var chatMessages = [chatMessage]()
    
    let chatUser: Employee?
    let DB = Firestore.firestore()
    var emp: Employee?
    
    init(chatUser: Employee?, emp:Employee? ) {
        self.emp = emp
        self.chatUser = chatUser
        fetchMessages()
    }
    
    func fetchMessages() {
       
        guard let toID = chatUser?.id else { return }
        guard let empID = emp?.employee_id else { return }
        
        DB.collection("texts").document(empID).collection(toID).order(by: "timestamp").addSnapshotListener { querySnapshot, error in
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

        guard let toID = chatUser?.id else { return }
        guard let empID = emp?.employee_id else { return }

        let document = DB.collection("texts").document(empID).collection(toID).document()
        
        let messageData = ["fromID" : empID, "toID" : toID, "text" : self.chatText, "timestamp" : Timestamp() ] as [String : Any]
        
        document.setData(messageData) { error in
            if error != nil {
                return
            }
            
            self.persistRecentMessage()
            
            self.chatText = ""
            self.count += 1
        }
        
        let recipientMessageDocument = DB.collection("texts").document(toID).collection(empID).document()
        
        recipientMessageDocument.setData(messageData) { error in
            if error != nil {
                return
            }
        }
        
    }
    
    
    private func persistRecentMessage() {
        
        guard let chatUser = chatUser else {
            return
        }
        
        guard let emp = emp else {
            return
        }

        guard let toID = self.chatUser?.id else { return }
                
        let data = [
            "timestamp": Timestamp(),
            "text": self.chatText,
            "fromID": emp.employee_id,
            "toID": toID,
            "username": chatUser.name,
            "senderName": emp.name,
            "receiverName": chatUser.name,
            "photoURL": chatUser.photoURL
        ] as [String : Any]
        
        DB.collection("recent_messages").document(emp.employee_id)
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
            "fromID": emp.employee_id,
            "toID": toID,
            "username": chatUser.name,
            "senderName": emp.name,
            "receiverName": chatUser.name,
            "photoURL": emp.photoURL
        ] as [String : Any]
        
        DB.collection("recent_messages").document(toID)
        .collection("messages")
        .document(emp.employee_id)
        .setData(data2) { error in
            if let error = error {
                print(error)
                return
            }
        }
    }
}
