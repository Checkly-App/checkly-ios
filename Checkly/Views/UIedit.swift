//
//  UIedit.swift
//  Checkly
//
//  Created by  Lama Alshahrani on 04/07/1443 AH.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseStorage


struct UIedit1: View {//
        @Environment(\.dismiss) var dismiss
        @State private var showingSheet = true

        @State var user = ""
         var name = ""
        @State private var userimage: UIImage?


        @ObservedObject private var viewModel = EmployeeViewModel()
        @State var toggleNotification = true
        @State var toggleLocation = true

        var listName: [String] = ["Terms And Conditions", "Privacy Policy", "Edit Profile","Change Password"]
        var listIcon: [String] = ["Terms", "privacy-1", "Editprofile","clock"]
        
        var listDestnation=[AnyView(ChangePasswordView()),AnyView(ChangePasswordView()),AnyView(ChangePasswordView()),AnyView(ChangePasswordView())] //This helped


        var body: some View {

            NavigationView{
             

                VStack{
                    List{

                    ForEach(0..<listName.count)
                    { listItem in

                        NavigationLink(destination: listDestnation[listItem]) {
                            
                        
                    HStack{
                        Image( listIcon[listItem]).foregroundColor(.gray)
                        Text(listName[listItem])
                            .font(.headline)
                            .fontWeight(.medium).foregroundColor(.black)
                        
                    }.padding() }
                        
                    }
                    
                    
                   
                    HStack{
              
                       
                            
                            Image("Notfication")
                        
                            
                               
                        Text("Turn off Notification")
                            .font(.footnote)
                            .fontWeight(.medium)
                           
                        Toggle(isOn: $toggleNotification) {
                            
                        }.tint(.cyan)
                    }.padding()
                    HStack{
                      
                                   Image("Location-1").foregroundColor(.gray)
                               
                        Text("Disable Location")
                            .font(.body)
                            .fontWeight(.medium)
    Spacer()
                        Toggle(isOn: $toggleLocation) {
                            
                        }.tint(.cyan)
                   }.padding()
                    Spacer()

                }
                }
                
                }.task
    {
                viewModel.fetchData()
            }.task{
                
                Storage.storage().reference().child("Emp1").getData(maxSize: 15*1024*1024){
                                (imageDate,err) in
                                if let err = err {
                                    print("error\(err.localizedDescription)")
                                } else {
                                    if let imageData = imageDate{
                                        self.userimage = UIImage(data: imageData)
                                    }
                                    
                                
                                else {
                                
                                        print("no error")
                                    
                                }
                                }
                            
                            }
            }
            }
}
  
    

   


struct UIedit_Previews: PreviewProvider {
    static var previews: some View {
UIedit1()    }
}
