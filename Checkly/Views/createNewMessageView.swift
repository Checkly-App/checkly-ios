//
//  createNewMessageView.swift
//  messages
//
//  Created by Norua Alsalem on 06/02/2022.
//

import SwiftUI
import FirebaseDatabase
import Firebase
import SDWebImageSwiftUI

class createNewMessageViewModel: ObservableObject {
    
    @Published var users = [Employee]()
    @Published var departments = [String]()
    let userID = "FJvmCdXGd7UWELDQIEJS3kisTa03"
    var companyID: String?
    var Department: String?
 
    
init() {
    getDepartment {
        getCompany {
            getCompanyDepartments {
                getCompanyEmployees()
            }
        }
    }
}

    
    
    func getCompanyEmployees(){

        let ref = Database.database().reference()
        let Queue = DispatchQueue.init(label: "Queue")


        Queue.sync {

        print("start search")
        ref.child("Employee").observe(.value, with: { dataSnapshot in
        for emp in dataSnapshot.children {
        let obj = emp as! DataSnapshot

        let name = obj.childSnapshot(forPath: "name").value as! String
        let id = obj.childSnapshot(forPath: "employee_id").value as! String
        let department = obj.childSnapshot(forPath: "department").value as! String
        let photoURL  = obj.childSnapshot(forPath: "image_token").value as! String
            
            let emp = Employee(id: id, name: name, department: department, photoURL: photoURL)
            
            if ( self.departments.contains(emp.department) ) {
                self.users.append(emp)
            }
            print(self.users)

        }
                        }, withCancel: { error in
                            print(error.localizedDescription)
                        })
                }
        print(self.users)
            }
    
    func getCompanyDepartments(completion: () -> Void) {
            
    let ref = Database.database().reference()
    let Queue = DispatchQueue.init(label: "Queue")
            
            
            Queue.sync {
                        
                print("start search")
                ref.child("Department").observe(.value, with: { dataSnapshot in
                    for dep in dataSnapshot.children {
                        let obj = dep as! DataSnapshot
                            
                        if ( obj.childSnapshot(forPath: "company_id").value as! String == self.companyID ) {
                        self.departments.append(obj.key)
                            }

                        print("departments are",self.departments)
                            
                            }
                    }, withCancel: { error in
                        print(error.localizedDescription)
                    })
            }
        completion()
        }
    
    
    func getCompany(completion: () -> Void){
        
        let ref = Database.database().reference()
        let Queue = DispatchQueue.init(label: "Queue")
        
        
        Queue.sync {
                    
            ref.child("Department/dep2").observe(.value, with: { dataSnapshot in

                    let obj = dataSnapshot.value as! [String:Any]

                    self.companyID = obj["company_id"] as! String
                        
                        
                }, withCancel: { error in
                    print(error.localizedDescription)
                })
        }
        completion()
    }
    

    func getDepartment(completion: () -> Void) {
    
  
    let ref = Database.database().reference()
    let Queue = DispatchQueue.init(label: "Queue")
    
        Queue.sync {
                
                print("start search")
                ref.child("Employee/FJvmCdXGd7UWELDQIEJS3kisTa03").observe(.value, with: { dataSnapshot in

                let obj = dataSnapshot.value as! [String:Any]


                let name = obj["name"] as! String
                let id = obj["employee_id"] as! String
                let department = obj["department"] as! String
                let photoURL = obj["image_token"] as! String
                    
                    let emp = Employee(id: id, name: name, department: department, photoURL: photoURL)
                    self.Department = emp.department
                    
                    print("XXXXXXXX",self.Department!,"XXXXXXXX")
                    
            }, withCancel: { error in
                print(error.localizedDescription)
            })
            
    }

        completion()
}
}



struct createNewMessageView: View {
    
    let didSelectNewUser: (Employee) -> ()
    
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var vm = createNewMessageViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView{
                Spacer()
                ForEach(vm.users) { user in
                    Button {
                        presentationMode.wrappedValue.dismiss()
                        didSelectNewUser(user)
                    } label: {
                        HStack{
                            if ( user.photoURL == "null") {
                                Image(systemName: "person.crop.circle.fill").foregroundColor(.gray)
                                    .font(.system(size: 45))
                            } else {
                                WebImage(url: URL(string: user.photoURL)).resizable().scaledToFill().frame(width: 45, height: 45).clipped().cornerRadius(64).overlay(RoundedRectangle(cornerRadius: 64).stroke(Color(.gray), lineWidth: 1)).shadow(radius: 5)
                            }
//                            Image(systemName: "person.circle.fill").foregroundColor(.gray)
//                                .font(.system(size: 30))
                            VStack (alignment: .leading){
                                Text(user.name).bold().foregroundColor(.black)
                                Text(user.department).font(.caption2).foregroundColor(.gray)
                            }
                            Spacer()
                        }.padding(1)
                            .padding(.leading)
                    }
                    
                     Divider()
                    
                }
            }.navigationTitle("New Message")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            presentationMode.wrappedValue.dismiss()
                        } label: {
                            Text("Cancel")
                        }

                    }
                }
        }
    }
}

struct createNewMessageView_Previews: PreviewProvider {
    static var previews: some View {
    messagesView()
    }
    
}
