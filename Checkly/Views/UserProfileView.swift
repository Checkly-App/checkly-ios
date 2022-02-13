//
//  UserProfileView.swift
//  Checkly
//
//  Created by  Lama Alshahrani on 06/07/1443 AH.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth



struct UserProfileView: View {
    let userid = Auth.auth().currentUser!.uid

    @Environment(\.dismiss) var dismiss
    @State private var showingSheet = false
    private var ref = Database.database().reference()

    @State var user = ""
     var name = ""
    @State private var userimage: UIImage?


    @ObservedObject private var viewModel = EmployeeViewModel()
    @State var toggleNotification = true
    @State var toggleLocation = true
    @State var ispresent1 = false
    @State var ispresent2 = false
    @State var ispresent3 = false


    var listName: [String] = ["Terms And Conditions", "Privacy Policy", "Edit Profile","Change Password"]
    var listIcon: [String] = ["Terms", "privacy-1", "Editprofile","clock"]
    
    var listDestnation=[AnyView(EditProfileView()),AnyView(EditProfileView()),AnyView(EditProfileView()),AnyView(EditProfileView())] //This helped


    var body: some View {
        NavigationView{
            ScrollView{
        VStack{
            VStack(spacing:8){
             
               if let image = self.userimage{
                    Image(uiImage: image).resizable().scaledToFill().frame(width: 137, height: 137)            .clipShape(Circle())

                    
                }
                
                else{
                Image("ProfileImage").resizable()
                        .frame(width: 137.0, height: 137.0)
                    
                }
                Text(viewModel.Employeeinfolist1)
                    .font(.title)
                    .fontWeight(.semibold)
                Text("\(viewModel.department) Department")
                    .font(.subheadline)
                    .fontWeight(.semibold)
               
                    .foregroundColor(Color.gray)
                Text(viewModel.position)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.cyan)
                Spacer()
                
            }.padding()
            VStack{
               
        
                    
                HStack{
                    Button {
                       ispresent1 = true
                    } label: {
                    Image("Terms").foregroundColor(.gray)
                    Text("Terms And Conditions")
                        .font(.headline)
                        .fontWeight(.medium).foregroundColor(.black)
Spacer()
                    
                               Image(systemName: "chevron.right").foregroundColor(.black)
                    
                    }   }.padding().fullScreenCover(isPresented: $ispresent1) {
                        EditProfileView()
                    }
                HStack{
                    Button {
                       ispresent2 = true
                    } label: {
                    Image("privacy-1").foregroundColor(.gray)
                    Text("Privacy Policy")
                        .font(.headline)
                        .fontWeight(.medium).foregroundColor(.black)
Spacer()
                    
                               Image(systemName: "chevron.right").foregroundColor(.black)
                    
                    }   }.padding().fullScreenCover(isPresented: $ispresent2) {
                        EditProfileView()
                    }
                HStack{
                    Button {
                       ispresent3 = true
                    } label: {
                    Image("Editprofile").foregroundColor(.gray)
                    Text("Edit profile")
                        .font(.headline)
                        .fontWeight(.medium).foregroundColor(.black)
Spacer()
                    
                               Image(systemName: "chevron.right").foregroundColor(.black)
                    
                    }   }.padding().fullScreenCover(isPresented: $ispresent3) {
                        EditProfileView()
                    }
                
                    
                
                Divider().padding()
               
                HStack{
                    
//                    Image(systemName: "bell.fill").foregroundColor(.gray)
                   
                        
                        Image("Notfication")
                    
                        
                           
                    Text("Turn off Notification")
                        .font(.callout)
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

            }.background(.white).cornerRadius(20).shadow(radius: 9).padding()
        }.navigationBarTitle("Profile").toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                           dismiss()
                       } label: {
                           HStack{
                Image(systemName: "chevron.left")
                               Text("Back").foregroundColor(Color("Blue"))
                           }

                       }
            }
        }.navigationBarTitleDisplayMode(.inline).background(Color(red: 236, green: 236, blue: 236)
)

            }.overlay(showingSheet ? LoadingView(): nil).task {
                print("profile")

                print(userid)
                showingSheet = true
            viewModel.fetchData()
            }.task{
//            ref.child("Employee").observe(.value) { snapshot in
          
            Storage.storage().reference().child(userid).getData(maxSize: 15*1024*1024){
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
                showingSheet = false
                        }
            
            
                    
            }.task {

                ref.child("Employee").child(userid).child("ChangeImage").observe(.value) { snapshot in
                              showingSheet = true
                Storage.storage().reference().child(userid).getData(maxSize: 15*1024*1024){
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
                    showingSheet = false
                            }
                
            }
            }
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
