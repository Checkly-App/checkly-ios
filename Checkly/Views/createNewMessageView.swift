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
    @Published var departments = ["dep1"]
    let userID = "8UoUAkIZvnP5KSWHydWliuZmOKt2"
 
    
    init() {
        getCompanyEmployees()
    }
    
    
//    private func searchDepartments() {
//        
//        let ref = Database.database().reference()
//        let searchQueue = DispatchQueue.init(label: "searchQueue")
//        
//        var department = fetchDepartment()
//        
//        searchQueue.sync {
//            ref.child("Department/\(department)").observe(.value, with: { dataSnapshot in
//
//            let obj = dataSnapshot.value as! [String:Any]
//
//            let company_id = obj["company_id"] as! String
//
//                let companyID = company_id
//
//                print("XXXXXXXXXXXXXXXXXXXXXXXXXXXXX", companyID)
//            })
//        }
//    }
    
//    func fetchDepartment() -> String{
//        var department: String?
//        getDepartment(){ dep in
//            department = dep
//        }
//        return department!
//    }
    
    
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
    
func getCompanyDepartments(){
            
    let ref = Database.database().reference()
    let Queue = DispatchQueue.init(label: "Queue")
            
            
            Queue.sync {
                        
                print("start search")
                ref.child("Department").observe(.value, with: { dataSnapshot in
                    for dep in dataSnapshot.children {
                        let obj = dep as! DataSnapshot
                            
                    if ( obj.childSnapshot(forPath: "company_id").value as! String == "com1" ) {
                        self.departments.append(obj.key)
                            }

                        print("departments are",self.departments)
                            
                            }
                    }, withCancel: { error in
                        print(error.localizedDescription)
                    })
            }
        }
    
    
func getCompany(){
        
        let ref = Database.database().reference()
        let Queue = DispatchQueue.init(label: "Queue")
        
        
        Queue.sync {
                    
                    print("start search")
                    ref.child("Department/dep1").observe(.value, with: { dataSnapshot in

                    let obj = dataSnapshot.value as! [String:Any]

                    let companyID = obj["company_id"] as! String

                        print("XXXXXXXXXXXXXXXXXXXXXXXXXXX",companyID)
                        
                        
                }, withCancel: { error in
                    print(error.localizedDescription)
                })
        }
    }
    

func getDepartment() -> String{
    
    let ref = Database.database().reference()
    let Queue = DispatchQueue.init(label: "Queue")
    var dep: String?
    
    Queue.sync {
                
                print("start search")
                ref.child("Employee/8UoUAkIZvnP5KSWHydWliuZmOKt2").observe(.value, with: { dataSnapshot in

                let obj = dataSnapshot.value as! [String:Any]


                let name = obj["name"] as! String
                let id = obj["employee_id"] as! String
                let department = obj["department"] as! String
                let photoURL = obj["image_token"] as! String
                    
                    let emp = Employee(id: id, name: name, department: department, photoURL: photoURL)
                    dep = emp.department
                    print("XXXXXXXXXXXXXXXXXXXXXXXXXXX",dep)
                    
                    
            }, withCancel: { error in
                print(error.localizedDescription)
            })
    }
    return dep!
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
