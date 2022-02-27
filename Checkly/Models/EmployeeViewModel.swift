
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
import FirebaseAuth

class EmployeeViewModel: ObservableObject {
  //  @Published var Employeeinfolist = [Employeeinfo]()
    let userid = Auth.auth().currentUser!.uid
   // @Published var selectrow9 = Set<Employee>()

    @Published var Employeeinfolist1 = ""
    @Published var email = ""
    @Published var position = ""
    @Published var department = ""
    @Published var address = ""
    @Published var gender = ""
    @Published var tokens = ""
    @Published var attendeeslist = [Employee]()

    @Published var gender1 = false
    @Published var gender2 = false
    @Published var Ischange = false
    @Published  var userimage: UIImage?
    @Published var emplyeelist = [Employee]()



    @Published var phonemum = ""
    @Published var companyid = ""

    @Published var nationalID = ""
    @Published var employeeID = ""
    @Published var birth = ""
    //@Published var userId = "111111111"











    private var ref = Database.database().reference()
    
    
    
    func UpdateData() {
       
        self.ref.child("Employee").child(userid).updateChildValues(["name": self.Employeeinfolist1, "phone_number": self.phonemum ])
                                                                  
       

        }
    
    func fetchData() {

        var user_id: String!
        var depid: String!
        var dep: String!

        var email: String!
        var phone: String!
        var position: String!
        var natid: String!
        var empid: String!
        var dateb: String!
        var gender0: String!
        var add: String!
        var toke: String!
        var comID: String!


        ref.child("Employee").observe(.value) { snapshot in

                for contact in snapshot.children{
              


                    let obj = contact as! DataSnapshot
                    if obj.key == self.userid {

                    depid = obj.childSnapshot(forPath: "department").value as? String
                    email = obj.childSnapshot(forPath: "email").value as? String
                    user_id = obj.childSnapshot(forPath: "name").value as? String
                    add = obj.childSnapshot(forPath: "address").value as? String
                    dateb = obj.childSnapshot(forPath: "birthdate").value as? String
                    empid = obj.childSnapshot(forPath: "employee_id").value as? String
                    gender0 = obj.childSnapshot(forPath: "gender").value as? String
                    natid = obj.childSnapshot(forPath: "national_id").value as? String
                    phone = obj.childSnapshot(forPath: "phone_number").value as? String
                    position = obj.childSnapshot(forPath: "position").value as? String
                        toke = obj.childSnapshot(forPath: "image_token").value as? String




                    self.Employeeinfolist1 = user_id
                    self.email = email
                    self.position = position
                    self.address = add
                    self.gender = gender0
                    self.nationalID = natid
                    self.employeeID = empid
                    self.birth = dateb
                    self.phonemum = phone
                    self.tokens = toke
                        if gender0 == "Female"{
                            self.gender2 = true
                            self.gender1 = false

                        }
                        else {
                            self.gender1 = true
                            self.gender2 = false
                        }
                }
        }
            
            self.ref.child("Department").observe(.value) { snapshot in

                    for contact in snapshot.children{
                  


                        let obj = contact as! DataSnapshot
                        if obj.key == depid {

                        dep = obj.childSnapshot(forPath: "name").value as? String
                            comID = obj.childSnapshot(forPath: "comapny_id").value as? String

        
                            self.department = dep
                            self.companyid = comID

           }
        
        
       
        
    }
            
        
    
}
        }
    }
    func fetchcompany() -> String {

        var user_id: String!
        var depid: String!
        var comID = ""


        ref.child("Employee").observe(.value) { snapshot in

                for contact in snapshot.children{
              


                    let obj = contact as! DataSnapshot
                    if obj.key == self.userid {

                    depid = obj.childSnapshot(forPath: "Department").value as? String
      
                        
                   
                }
        }
            
            self.ref.child("Department").observe(.value) { snapshot in

                    for contact in snapshot.children{
                  


                        let obj = contact as! DataSnapshot
                        if obj.key == depid {
                            comID = ((obj.childSnapshot(forPath: "comapny_id").value as? String)!)
                            
                         

           }
//     return comID
        
       
        
    }
            
        
    
}
        }
        return comID

    }
        
        func fetchDatalist() {

            var nameem: String!
            var depid: String!
            var dep: String!
            var userid: String!


            var email: String!
            var phone: String!
            var position: String!
            var natid: String!
            var empid: String!
            var dateb: String!
            var gender0: String!
            var add: String!
            var toke: String!
            var comID: String!

            let usercompanyID = fetchcompany()







            ref.child("Employee").observe(.value) { snapshot in

                    for contact in snapshot.children{
                  


                        let obj = contact as! DataSnapshot
                        userid = obj.key
                       
                        depid = obj.childSnapshot(forPath: "department").value as? String
                        email = obj.childSnapshot(forPath: "email").value as? String
                        nameem = obj.childSnapshot(forPath: "name").value as? String
                        add = obj.childSnapshot(forPath: "address").value as? String
                        dateb = obj.childSnapshot(forPath: "birthdate").value as? String
                        empid = obj.childSnapshot(forPath: "employee_id").value as? String
                        gender0 = obj.childSnapshot(forPath: "gender").value as? String
                        natid = obj.childSnapshot(forPath: "national_id").value as? String
                        phone = obj.childSnapshot(forPath: "phone_number").value as? String
                        position = obj.childSnapshot(forPath: "position").value as? String
                            toke = obj.childSnapshot(forPath: "image_token").value as? String

                        self.ref.child("Department").observe(.value) { snapshot in

                                for contact in snapshot.children{



                                    let obj = contact as! DataSnapshot
                                    if obj.key == depid {
                                        dep = obj.childSnapshot(forPath: "name").value as? String
                                        comID = obj.childSnapshot(forPath: "ComapnyID").value as? String


                       }

                                    if comID == nil{
                                        comID = "not"
                                    }
                                    if dep == nil{
                                        dep = "not"
                                    }


                }
                        }
                        
                        if comID == nil{
                            comID = "not"
                        }
                        if dep == nil{
                            dep = "not"
                        }
                        
            
                let employee = Employee( id:userid,name:nameem,position: position,department: dep ,birthdate: dateb ,tokens:toke,address:add,phone: phone,NationalID:natid ,EmplyeeId: empid ,gender: gender0,emaill:email,comid:comID)
                    print(employee)
//                if employee.comid == usercompanyID {
                    self.emplyeelist.append(employee)
                    }
                }
            }
        
            
           
            

    }

    

