//
//  UserProfile.swift
//  Scheak
//
//  Created by  Lama Alshahrani on 01/07/1443 AH.
//

import SwiftUI
import Firebase
import FirebaseDatabase


struct UserProfile: View {
    @Environment(\.dismiss) var dismiss

    @State var user = ""
     var name = ""

    @ObservedObject private var viewModel = EmployeeViewModel()

    @State var employeeName = ""
    var body: some View {
        VStack{
          
            Button {
                dismiss()

            } label: {
                Image(systemName: "arrow.left").font(.system(size: 40.0)).foregroundColor(.white)
            }.padding(.trailing,300)
            Button(action: {
                dismiss()
            }) {
                Image("marker")
            }
            Image(systemName: "person.circle.fill")
                                                                                                                                                                                                        .foregroundColor(.white)
                                                                                                                                                                                                        .imageScale(.large).font(.system(size: 100.0)).padding(.top,10)
            Text(viewModel.Employeeinfolist1).fontWeight(.semibold).foregroundColor(Color(hue: 1.0, saturation: 0.015, brightness: 0.345)).padding(.top,0)
            Text("\(viewModel.position) |\(viewModel.department)").fontWeight(.regular).foregroundColor(.gray).padding(.top,0.2)
            ZStack{
                VStack(alignment: .leading,spacing: 10){
                    VStack(alignment: .leading){ Text("Email:").frame( alignment: .leading).foregroundColor(.gray)
                        Text(viewModel.email)
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,50)
                    
                 
                   
                    VStack(alignment: .leading){ Text("Gender:").frame( alignment: .leading).foregroundColor(.gray)
                        Text(viewModel.gender)
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,10)
                    VStack(alignment: .leading){ Text("Address:").frame( alignment: .leading).foregroundColor(.gray)
                        Text(viewModel.address)
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,10)
                    VStack(alignment: .leading){ Text("Birth Date:").frame( alignment: .leading).foregroundColor(.gray)
                        Text(viewModel.birth)
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,10)
                    VStack(alignment: .leading){ Text("Employee ID:").frame( alignment: .leading).foregroundColor(.gray)
                        Text(viewModel.employeeID)
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,10)
                    VStack(alignment: .leading){ Text("National ID:").frame( alignment: .leading).foregroundColor(.gray)
                        Text(viewModel.nationalID)
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,10)
                    VStack(alignment: .leading){ Text("Phone Number:").frame( alignment: .leading).foregroundColor(.gray)
                        Text(viewModel.phonemum)
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,10)
Spacer()
                }.frame( alignment: .leading).padding(.leading,-150)
                
                
                
            }.frame( maxWidth: .infinity,  maxHeight: .infinity).background(.white).cornerRadius(30).padding(.top,35).shadow(radius: 4.0)
            Spacer() }.frame( maxWidth: .infinity,  maxHeight: .infinity).background( LinearGradient(gradient: Gradient(colors: [Color(red: 207/255, green: 242/255, blue: 242/255), Color(red: 210/255, green: 236/255, blue: 249/255)]), startPoint: .top, endPoint: .bottom)).onAppear(perform: {
                
                
                
                self.viewModel.fetchData()

                //read()
                
                
                
            }
            )
                                                                         
        
            }
//    func read(){
//       // let db = Firestore.firestore()
//let ref = Database.database().reference()
//        print("in1)")
//
//       ref.child("Employee").observe(.value) { snapshot in
//           print("enter")
//
//            for contact in snapshot.children{
//              print("enter1")
//                let obj = contact as! DataSnapshot
//                let user_id = obj.childSnapshot(forPath: "Name").value as! String
//                print(user_id)
//                DispatchQueue.main.sync {
//
//
//                    user = obj.childSnapshot(forPath: "Name").value as! String}
//        print("hi")
//
//    }
//
//
//       }}
    
    
}


struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        
        UserProfile()
.previewInterfaceOrientation(.portraitUpsideDown)
    }
}
