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
    
    var emp: Employee
    @Published var users = [Employee]()
    @Published var departments = [String]()
    var companyID: String?
   
 
    
    init(emp: Employee) {
        self.emp = emp
        getCompany {
            getCompanyDepartments {
                getCompanyEmployees()
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
        let birthdate = obj.childSnapshot(forPath: "birthdate").value as! String
        let phone_number = obj.childSnapshot(forPath: "phone_number").value as! String
        let position = obj.childSnapshot(forPath: "position").value as! String
        let email  = obj.childSnapshot(forPath: "email").value as! String
        let gender = obj.childSnapshot(forPath: "gender").value as! String
        let address = obj.childSnapshot(forPath: "address").value as! String
        let national_id = obj.childSnapshot(forPath: "national_id").value as! String

            
            let emp = Employee(employee_id: id, address: address, birthdate: birthdate, department: department, email: email, id: id, gender: gender, name: name, national_id: national_id, phone_number: phone_number, position: position, photoURL: photoURL)
            
            if ( self.departments.contains(emp.department) && emp.employee_id != self.emp.employee_id  ) {
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
                    
            ref.child("Department/\(emp.department)").observe(.value, with: { dataSnapshot in

                    let obj = dataSnapshot.value as! [String:Any]

                    self.companyID = obj["company_id"] as! String
                        
                        
                }, withCancel: { error in
                    print(error.localizedDescription)
                })
        }
        completion()
    }

}


struct createNewMessageView: View {
    
   
    
    @Environment(\.presentationMode) var presentationMode
    
    var emp: Employee
    @ObservedObject var vm: createNewMessageViewModel
    
    init(emp: Employee, didSelectNewUser: @escaping (Employee) -> () ) {
        self.emp = emp
        self.vm = .init(emp: emp)
        self.didSelectNewUser = didSelectNewUser
    }
    
    let didSelectNewUser: (Employee) -> ()
    
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
    
    static let employee = Employee(employee_id: "", address: "", birthdate: "", department: "", email: "", id: "", gender: "", name: "", national_id: "", phone_number:  "", position: "", photoURL: "")
    
    static var previews: some View {
        messagesView(emp: employee)
    }
    
}
