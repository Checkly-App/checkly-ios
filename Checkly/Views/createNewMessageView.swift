//
//  createNewMessageView.swift
//  messages
//
//  Created by Norua Alsalem on 06/02/2022.
//

import SwiftUI
import FirebaseDatabase
import Firebase

class createNewMessageViewModel: ObservableObject {
    
    @Published var users = [Employee]()
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        
        let ref = Database.database().reference()
        let searchQueue = DispatchQueue.init(label: "searchQueue")
        
        searchQueue.sync {
            ref.child("Employee").observe(.childAdded) { snapshot in
                
                let obj = snapshot.value as! [String: Any]
                let name = obj["Name"] as! String
                let id = obj["employeeID"] as! String
                let department = obj["Department"] as! String
                let photoURL = obj["tokens"] as! String

                
                let emp = Employee(id: id, name: name, department: department, photoURL: photoURL)
                    //auth
                if ( emp.id != "111111111")  {
                    self.users.append(emp)
            }
            }
        }
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
                            Image(systemName: "person.circle.fill").foregroundColor(.gray)
                                .font(.system(size: 30))
                            VStack (alignment: .leading){
                                Text(user.name).bold().foregroundColor(.black)
                                Text(user.department).font(.caption2).foregroundColor(.gray)
                            }
                            Spacer()
                        }
                    }
                    .padding(.horizontal)
                     Divider()
                    .padding(.vertical)
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
