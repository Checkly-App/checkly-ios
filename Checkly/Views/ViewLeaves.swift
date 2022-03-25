//
//  ViewLeaves.swift
//  Checkly
//
//  Created by Norua Alsalem on 25/03/2022.
//

import SwiftUI
import Firebase
import FirebaseDatabase

struct ViewLeaves: View {
    
    @ObservedObject var vm = ViewLeaveViewModel()
    
    var body: some View {
        ForEach (vm.leaves,  id: \.self) { leave in
                
            Text(leave.type)
        
    }
}
    
}

class ViewLeaveViewModel: ObservableObject {
    
    init() {
        fetchLeaves()
    }
    
    @Published var leaves = [Leave]()
    
    func fetchLeaves () {
        
        let ref = Database.database().reference()
        let searchQueue = DispatchQueue.init(label: "searchQueue")
        
    searchQueue.sync {
        
        ref.child("Leave").observe(.value, with: { dataSnapshot in

            for child in dataSnapshot.children {
                let snap = child as! DataSnapshot
                let obj = snap.value as! [String: Any]
                let start_date = obj["start_date"] as! String
                let end_date = obj["end_date"] as! String
                let status = obj["status"] as! String
                let type = obj["type"] as! String
                let notes = obj["notes"] as! String
                
            
                let Leave = Leave(start_date: start_date, end_date: end_date, status: status, notes: notes, document: "", id: "", type: type)
                
                self.leaves.append(Leave)
            }
        })
    }
        print(self.leaves)
        
    }
    
}

struct ViewLeaves_Previews: PreviewProvider {
    static var previews: some View {
        ViewLeaves()
    }
}
