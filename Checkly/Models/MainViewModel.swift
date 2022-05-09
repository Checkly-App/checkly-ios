//
//  MainViewModel.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 06/08/1443 AH.
//
import Foundation
import Firebase
import FirebaseStorage
import FirebaseMessaging

class MainViewModel: ObservableObject{
    
    //MARK: - Published variables
    @Published static var emp:Employee
    @Published static var dep:Department
    @Published static var com:Company
    
    //MARK: - Public variables
    var ref = Database.database().reference()
    var storageRef = Storage.storage().reference()
    let loggedInUserID = "PIfzRqUP9FdUf8cAr1UKHmxtEK12"
    var companyAuth: String = ""
    var isHomeLoaded = false
    
    
    //MARK: - init function
    init(){
        //1- initilize the published employee , department and company variables
        emp = Employee(address: "", birthdate: "", department: "", email: "", employee_id: "", gender: "", name: "", national_id: "", phone_number: "", position: "", token: "")
        dep = Department(company_id: "", dep_id: "", manager: "", name: "")
        com = Company(abbreviation: "", age: "", attendance_strategy: "", industry: "", location: "", name: "", policy: "", size: "", id: "", working_hours: "", geo_id: "", email: "")
        //2- load home info
        registerDeviceToken()
        loadHome()
        
    }
    
    //MARK: - Private Functions
    /// a function that returns the current time as string
    /// - Returns: string indicates the current time in the format HH:mm
    func getTime()->String{
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let stringDate = timeFormatter.string(from: time)
        return stringDate
    }

    /// a function that returns the current date as string
    /// - Returns: string indicates the current date in the format EEEE, MMM d
    func getDate()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMM d")
        return dateFormatter.string(from: Date())
    }
    
    private func registerDeviceToken(){
        ref.child("Employee").child(loggedInUserID).child("token").setValue(Messaging.messaging().fcmToken)
    }
    
    private func loadCompanyImage(completion: @escaping (Bool) -> Void){
        storageRef.child("Companies").child("\(companyAuth).png").downloadURL { url, error in
            guard error == nil else {
                print("ERROR DOENLOADING THE EMPLOYEE IMAGE: \(error!.localizedDescription)")
                completion(false)
                return
            }
            self.com.image = url!
            print("\(self.com.image!)")
            completion(true)
        }
    }
    
    
    private func loadCompanyInfo(completion: @escaping (Bool) -> Void){
        ref.child("Company").child(dep.company_id).observeSingleEvent(of: .value) { snapshot in
            let obj = snapshot.value as! [String: Any]
            self.com = Company(abbreviation: obj["abbreviation"] as! String, age: obj["age"] as! String, attendance_strategy: obj["attendance_strategy"] as! String, industry: obj["industry"] as! String, location: obj["location"] as! String, name: obj["name"] as! String, policy: obj["Policy"] as! String, size: obj["size"] as! String, id: obj["com_id"] as! String, working_hours: obj["working_hours"] as! String, geo_id: obj["geo_id"] as! String, email: obj["email"] as! String)
            self.companyAuth = snapshot.key
            print("COMPANY KEY: \(self.companyAuth)")
            completion(true)
        } withCancel: { error in
            print("ERROR: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    private func loadDepartmentInfo(completion: @escaping (String) -> Void){
        ref.child("Department").child(emp.department).observeSingleEvent(of: .value) { snapshot in
            let obj = snapshot.value as! [String: Any]
            let dep = Department(company_id: obj["company_id"] as! String, dep_id: obj["dep_id"] as! String, manager: obj["manager"] as! String, name: obj["name"] as! String)
            self.dep = dep
            completion(dep.company_id)
            print(dep)
        }
    }
    
    private func loadEmployeeImage(completion: @escaping (Bool) -> Void){
        storageRef.child("Employees").child("\(loggedInUserID).png").downloadURL { url, error in
            guard error == nil else{
                print("ERROR DOENLOADING THE EMPLOYEE IMAGE: \(error!.localizedDescription)")
                completion(false)
                return
            }
            self.emp.image = url!
            completion(true)
        }
    }
    
    private func loadEmployeeInfo(completion: @escaping (Bool) -> Void){
        ref.child("Employee").child(loggedInUserID).observeSingleEvent(of: .value) { snapshot in
            let obj = snapshot.value as! [String: Any]
            self.emp = Employee(address: obj["address"] as! String, birthdate: obj["birthdate"] as! String, department: obj["department"] as! String, email: obj["email"] as! String, employee_id: obj["employee_id"] as! String, gender: obj["gender"] as! String, name: obj["name"] as! String, national_id: obj["national_id"] as! String, phone_number: obj["phone_number"] as! String, position: obj["position"] as! String, token: obj["token"] as! String )
            print(self.emp)
            completion(true)
        } withCancel: { error in
            print("ERROR: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    
    func loadHome(){
        //1- load employee info
        loadEmployeeInfo { employeeLoaded in
            if employeeLoaded{
                //2- load employee image
                self.loadEmployeeImage { empImageLoaded in
                    if empImageLoaded{
                        //4- load department info
                        self.loadDepartmentInfo { com_id in
                            if com_id != ""{
                                //5- load the company info
                                self.loadCompanyInfo { company in
                                    if company{
                                        //6- load the company image
                                        self.loadCompanyImage { companyImageLoaded in
                                            if companyImageLoaded {
                                                print("LOADED HOME INFO SUCCESSFULY!")
                                                //7- home is loaded now
//                                                self.sendPushNotification(attendanceType: "check-out",is)
                                                self.isHomeLoaded = true
                                            }else{
                                                print("failed to load company image")
                                            }
                                        }
                                    }else{
                                        print("failed to load company")
                                    }
                                }
                            }else{
                                print("failed to load com_id")
                            }
                        }
                    }else{
                        print("failed to load EmployeeImage")
                    }
                }
            }else{
                print("failed to loadEmployeeInfo")
            }
        }
    }
}
