//
//  tabModel.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 06/08/1443 AH.
//

import Foundation
import FirebaseDatabase

class tabViewModel: ObservableObject{
    
    @Published var isMessagesViewLoaded = false
    @Published var isCalendarViewLoaded = false
    @Published var isStatisticsViewLoaded = false
    @Published var isServicesLoaded = false
    @Published var emp : Employee = Employee(address: "", birthdate: "", department: "", email: "", id: "", gender: "", name: "", national_id: "", phone_number: "", position: "", photoURL: "")
    
    //    let uuid = Auth.auth().currentUser?.uid
    private let loggedInUserID = "PIfzRqUP9FdUf8cAr1UKHmxtEK12"
    private var ref = Database.database().reference()
    
    init(){
        loadHome()
    }
    
    
    func loadHome(){
        ref.child("Employee").child(loggedInUserID).observeSingleEvent(of: .value) { snapshot in
            let obj = snapshot.value as! [String: Any]
            let uuid = snapshot.key
            if uuid == self.loggedInUserID {
                DispatchQueue.main.async {
                    self.emp = Employee(address: obj["address"] as! String, birthdate: obj["birthdate"] as! String, department: obj["department"] as! String, email: obj["email"] as! String, id: obj["employee_id"] as! String, gender: obj["gender"] as! String, name: obj["name"] as! String, national_id: obj["national_id"] as! String, phone_number: obj["phone_number"] as! String, position: obj["position"] as! String, photoURL: obj["image_token"] as! String)
                    print(self.emp)
                }
            }
        } withCancel: { error in
            print(error.localizedDescription)
        }
    }
    
    func loadMessages(){
        print("Messages loaded")
        isMessagesViewLoaded = true
    }
    
    func loadCalendar(){
        print("Calendar loaded")
        isCalendarViewLoaded = true
    }
    
    func loadStatistics(){
        print("Statistics loaded")
        isStatisticsViewLoaded = true
    }
    
    func loadServices(){
        print("Services loaded")
        isServicesLoaded = true
    }
}

