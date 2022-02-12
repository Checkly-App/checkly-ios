
//
//  EmployeeViewModel.swift
//  Checkly
//
//  Created by  Lama Alshahrani on 02/07/1443 AH.
//



import Foundation
import Firebase
import FirebaseDatabase
import FirebaseStorage
import SwiftUI

class EmployeeViewModel: ObservableObject {
  //  @Published var Employeeinfolist = [Employeeinfo]()
    
    @Published var Employeeinfolist1 = ""
    @Published var email = ""
    @Published var position = ""
    @Published var department = ""
    @Published var address = ""
    @Published var gender = ""
    @Published var gender1 = false
    @Published var gender2 = false
    @Published var Ischange = false
    @Published  var userimage: UIImage?



    @Published var phonemum = ""
    @Published var nationalID = ""
    @Published var employeeID = ""
    @Published var birth = ""
    @Published var userId = "111111111"











    private var ref = Database.database().reference()
    
    
    
    func UpdateData() {
       
        self.ref.child("Employee").child("111111111").updateChildValues(["Name": self.Employeeinfolist1, "phoneNumber": self.phonemum ])
                                                                  
       

        }
    
    func fetchData() {
       
           // let db = Firestore.firestore()
   // let ref = Database.database().reference()
            print("in1)")
        var user_id: String!
        var dep: String!
        var email: String!
        var phone: String!
        var position: String!
        var natid: String!
        var empid: String!
        var dateb: String!
        var gender0: String!
        var add: String!








        ref.child("Employee").observe(.value) { snapshot in
               print("enter")

                for contact in snapshot.children{
              

                  print("enter1")

                    let obj = contact as! DataSnapshot
                    if obj.key == "111111111"{

                    dep = obj.childSnapshot(forPath: "Department").value as? String
                    email = obj.childSnapshot(forPath: "Email").value as? String
                    user_id = obj.childSnapshot(forPath: "Name").value as? String
                    add = obj.childSnapshot(forPath: "address").value as? String
                    dateb = obj.childSnapshot(forPath: "birthdate").value as? String
                    empid = obj.childSnapshot(forPath: "employeeID").value as? String
                    gender0 = obj.childSnapshot(forPath: "gender").value as? String
                    natid = obj.childSnapshot(forPath: "nationalID").value as? String
                    phone = obj.childSnapshot(forPath: "phoneNumber").value as? String
                    position = obj.childSnapshot(forPath: "position").value as? String


//                    print(user_id!)
//                    let emp = Employeeinfo(name: user_id)
//                    self.Employeeinfolist.append(emp)
                    self.Employeeinfolist1 = user_id
                    self.department = dep
                    self.email = email
                    self.position = position
                    self.address = add
                    self.gender = gender0
                    self.nationalID = natid
                    self.employeeID = empid
                    self.birth = dateb
                    self.phonemum = phone
                       
                        if gender0 == "Female"{
                            self.gender2 = true
                            self.gender1 = false

                        }
                        else {
                            self.gender1 = true
                            self.gender2 = false
                        }
            print("hi")
                }
        }
              
        

           }
        
        
       
        
    }
            
        
    
}
