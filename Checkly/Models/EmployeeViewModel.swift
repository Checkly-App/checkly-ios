
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
    @Published var departmentid = ""

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
    @Published var comid0 = ""
    @Published var depname = ""
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
                            comID = obj.childSnapshot(forPath: "company_id").value as? String

        
                            self.department = dep
                            self.companyid = comID

           }
        
        
       
        
    }
            
        
    
}
        }
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



            DispatchQueue.main.async {
                self.ref.child("Employee").observe(.value) { [self] snapshot in

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
                        let employee = Employee( id:userid,name:nameem,position: position,department:depid,birthdate: dateb ,tokens:toke,address:add,phone: phone,NationalID:natid ,EmplyeeId: empid ,gender: gender0,emaill:email,comid:self.comid0)
                        self.finddep(Empl: employee)
                        
                    }}
            }
        
    }
    func finddep(  Empl  :  Employee ){
        var depid: String!
        var comIDuser: String!



        ref.child("Employee").observe(.value) { snapshot in
                for contact in snapshot.children{
              


                    let obj = contact as! DataSnapshot
                    if obj.key == self.userid {

                    depid = obj.childSnapshot(forPath: "department").value as? String
                       
                    }
                }
        
                        self.ref.child("Department").observe(.value) { snapshot in
            
                                for contact in snapshot.children{
            
            
            
                                    let obj = contact as! DataSnapshot
                                    if obj.key == depid {
                                        comIDuser = ((obj.childSnapshot(forPath: "company_id").value as? String)!)
                                      
            
                       }
                                }
        var emp = Empl
    var comID: String!
    var dep: String!

                            self.ref.child("Department").observe(.value) { snapshot in
  
                                  for contact in snapshot.children{
  
  
                                      let obj = contact as! DataSnapshot
                                      if obj.key == emp.department {
                                          dep = obj.childSnapshot(forPath: "name").value as? String
                                      //    comID = obj.childSnapshot(forPath: "name").value as? String
                                          self.depname =                                           (obj.childSnapshot(forPath: "name").value as? String)!
                                        dep = obj.childSnapshot(forPath: "name").value as? String
  
                                          comID = (obj.childSnapshot(forPath: "company_id").value as? String)!
                                          emp.department = dep
  
                                          emp.comid = comID
  
//
                                          if emp.comid == comIDuser  && emp.id != self.userid {
                                      self.emplyeelist.append(emp)
                                          }

                          
                                  }
                        }
                                     
                                  }
                          
                        }
        }
    }
    

@Published var MeetingId = ""
    @Published var IsSelectedSite = false
    @Published var isSelectedinline = false
    @Published var isonsite = false
    @Published var date0 = Date()

    @Published var selectrow = Set<Employee>()

    @Published var attendeneslist0: [Employee] = []
    @Published var attendetry: [String] = []


    @Published var MeetingObjattendeneess : [String: String] = [:]
   // @Published var Meeti : Meeting()
    @Published var MeetingObj = Meeting(id: "", host: "", title: "", date: Date(), type: "", location: "", attendees: ["":""], agenda: "", end_time: Date(), latitude: "", longitude: "")
    func getMeetings(meetingid:String){
        var attendeneslist0: [Employee] = []
        self.fetchDatalist()

            let ref = Database.database().reference()
            
            DispatchQueue.main.async {
                ref.child("Meetings").observe(.value) { snapshot in
                    
                    for contact in snapshot.children{
              

                        
                            let obj = contact as! DataSnapshot
                    if obj.key  as! String == meetingid {


                    let agenda =  obj.childSnapshot(forPath: "agenda").value as? String
                        let attendees =  obj.childSnapshot(forPath: "attendees").value as? [String:String]
                    let date =   obj.childSnapshot(forPath: "datetime_start").value as? Int
                    let end_time =  obj.childSnapshot(forPath: "datetime_end").value as? Int
                    let host =  obj.childSnapshot(forPath: "host").value as? String
                    let latitude =  obj.childSnapshot(forPath: "latitude").value as? String
                    let location =  obj.childSnapshot(forPath: "location").value as? String
                    let longitude =  obj.childSnapshot(forPath: "longitude").value as? String
                    let title =   obj.childSnapshot(forPath: "title").value as? String
                    let type =  obj.childSnapshot(forPath: "type").value as? String
                    let meeting_id = obj.key
                        for mt in attendees! {
                            self.MeetingObjattendeneess[mt.key] = mt.value
                        }
                        let mt = Meeting(id: meeting_id, host: host!, title: title!, date: .init(timeIntervalSince1970: TimeInterval(date!)), type: type!, location: location!, attendees: attendees!, agenda: agenda!, end_time: .init(timeIntervalSince1970: TimeInterval(end_time!)), latitude: latitude!, longitude: longitude!)
                        self.MeetingObj = mt

                        if mt.type == "On-site"{

                            self.IsSelectedSite = true
                            self.isSelectedinline = false
                            self.isonsite = true
                        }
                        else {
                            self.IsSelectedSite = false
                            self.isSelectedinline = true
                            self.isonsite = false
                        }
                       
                        for em2 in attendees! {
                            self.attendetry.append(em2.key)
                        }
                        for emp1 in self.emplyeelist {
                            for em2 in attendees! {
                                if em2.key == emp1.id {
                                 attendeneslist0.append(emp1)
                                    print("wor")
                                    self.selectrow.insert(emp1)

                                }
                            }
                        }
                      

                      print(attendeneslist0)
                      
                       

                }
                }
                }
              
                
            }
      
}
}

    

    

