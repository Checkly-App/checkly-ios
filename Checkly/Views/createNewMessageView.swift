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
    
    init() {
        fetchAllUsers()
    }
    
    private func fetchAllUsers() {
        
        let ref = Database.database().reference()
        let searchQueue = DispatchQueue.init(label: "searchQueue")
        
        searchQueue.sync {
            ref.child("Employee").observe(.childAdded) { snapshot in
                
                let obj = snapshot.value as! [String: Any]
                let name = obj["name"] as! String
                let id = obj["employee_id"] as! String
                let department = obj["department"] as! String
                let photoURL = obj["image_token"] as! String

                
                let emp = Employee(id: id, name: name, department: department, photoURL: photoURL)
                    //auth
                if ( emp.id != "8UoUAkIZvnP5KSWHydWliuZmOKt2")  {
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
