//
//  messagesViewModel.swift
//  messages
//
//  Created by Noura Alsulayfih on 07/07/1443 AH.
//

import Foundation
import Firebase


class messagesViewModel: ObservableObject {
    
    @Published var recentMessages = [recentMessage]()
    let userID = "111111111"

    
    init() {
        fetchRecentMessages()
    }
        
    private func fetchRecentMessages() {

        let DB = Firestore.firestore()
        let userID = "111111111"

        DB.collection("recent_messages").document(userID).collection("messages").order(by: "timestamp").addSnapshotListener { querySnapshot, error in
            if let error = error {
                print(error)
                return
            }

            querySnapshot!.documentChanges.forEach({ change in

                let docID = change.document.documentID

                if let index = self.recentMessages.firstIndex(where: { rm in
                    rm.id == docID
                }) {
                    self.recentMessages.remove(at: index)
                }

                let fromID = change.document.data()["fromID"] as! String
                let text = change.document.data()["text"] as! String
                let timestamp = change.document.data()["timestamp"] as! Timestamp
                let toID = change.document.data()["toID"] as! String
                let username = change.document.data()["username"] as! String
                let senderName = change.document.data()["senderName"] as! String
                let receiverName = change.document.data()["receiverName"] as! String
                let photoURL = change.document.data()["photoURL"] as! String

                let rm = recentMessage(id: docID, fromID: fromID, toID: toID, text: text, username: username, timestamp: timestamp.dateValue(), senderName: senderName, receiverName: receiverName, photoURL: photoURL)
                self.recentMessages.insert(rm, at: 0)

            })
            print("recent\(self.recentMessages)")
        }
    }
    
    func fetchSelectedUser(n: String) -> Employee{
        var employee: Employee?
        getSelectedUser(id: n){ emp in
            employee = emp
        }
        return employee!
    }
    
    func getSelectedUser(id: String, completion: @escaping (Employee)->Void){
        
        let ref = Database.database().reference()
        let Queue = DispatchQueue.init(label: "Queue")
        
        Queue.sync {
                let idtosearch = id
                ref.child("Employee").queryOrdered(byChild: "employee_id").queryEqual(toValue: idtosearch).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                    print("XXXXXXXXXXXXXXXXXXXXXXX\(snapshot.key)")
                    let newId = snapshot.key
                    print("XXXXXXXXXXXXXXXXXXXXXXX\(newId)")
                    
                    print("start search")
                    ref.child("Employee/\(newId)").observe(.value, with: { dataSnapshot in

                    let obj = dataSnapshot.value as! [String:Any]


                    let name = obj["name"] as! String
                    let id = obj["employee_id"] as! String
                    let department = obj["department"] as! String
                    let photoURL = obj["image_token"] as! String

                    let emp = Employee(id: id, name: name, department: department, photoURL: photoURL)
                    

                        print("done with search")
                        completion(emp)

                }, withCancel: { error in
                    print(error.localizedDescription)
                })
                    
                })
        }
    }
}

