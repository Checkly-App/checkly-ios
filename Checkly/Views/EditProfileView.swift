//
//  EditProfileView.swift
//  Checkly
//
//  Created by  Lama Alshahrani on 03/07/1443 AH.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseStorage

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var userimage: UIImage?


    @ObservedObject private var viewModel = EmployeeViewModel()
   @State var username: String = ""
   // @State var username: String = viewModel.phonemum
    var body: some View {
        
        ZStack{
              NavigationView {
                  
                  VStack(){
                      VStack{
                          VStack{
                              Button {
                                  showingImagePicker = true

                              

                              } label: {
                                  if let image = self.inputImage{
                                      Image(uiImage: image).resizable().scaledToFill().frame(width: 128, height: 128).cornerRadius(70)
                                  }else {if let image = self.userimage{
                                      Image(uiImage: image).resizable().scaledToFill().frame(width: 128, height: 128).cornerRadius(70)
                                  }else{
                                      Image(systemName: "person.circle.fill")
                                                                                                                                                                                                                      .foregroundColor(.cyan)
                                      .imageScale(.large).font(.system(size: 100.0)).padding(.top,13)}}
                              }.padding(.trailing,1).fullScreenCover(isPresented: $showingImagePicker) {
                                  ImagePicker(image: $inputImage)
                }
                          }
                      
                          VStack{
                          HStack(alignment: .center) {
                              Text("Name:")
                                  .bold().foregroundColor(.cyan)
                              TextField("Enter your name...", text:$viewModel.Employeeinfolist1)
                                  
                          }.padding(.top,10).padding(.leading,20)
                              Divider()
                              
                          }
                          VStack (alignment: .leading){
                              
                              HStack{ Text("Email:").frame( alignment: .leading).foregroundColor(.gray)
                                  Text(viewModel.email)
                                      .foregroundColor(Color.black)
                                  
                              }.padding(.top,10).padding(.leading,13)
                              Divider()
                              VStack(alignment: .leading) {
                                  HStack{ Text("Position:").frame( alignment: .leading).foregroundColor(.gray)
                                      Text(viewModel.position)
                                          .foregroundColor(Color.black)
                                      
                                  }.padding(.top,10).padding(.leading,13)
                             Divider() }
                              
                             
                              HStack{ Text("Gender:").frame( alignment: .leading).foregroundColor(.gray)
                                  Text(viewModel.gender)
                                      .foregroundColor(Color.black)
                                  
                              }.padding(.top,10).padding(.leading,13)
                              Divider()
                              
                              VStack(alignment: .leading) {
                                  HStack{ Text("Department:").frame( alignment: .leading).foregroundColor(.gray)
                                      Text(viewModel.department)
                                          .foregroundColor(Color.black)
                                      
                                  }.padding(.top,10).padding(.leading,13)
                             Divider() }
                              VStack (alignment: .leading){
                                  HStack{ Text("Address:").frame( alignment: .leading).foregroundColor(.gray)
                                      Text(viewModel.address)
                                          .foregroundColor(Color.black)
                                      
                                  }.padding(.top,10).padding(.leading,13)
                              Divider()}
                              
                              VStack(alignment: .leading) {
                                  HStack{ Text("Birth Date:").frame( alignment: .leading).foregroundColor(.gray)
                                      Text(viewModel.birth)
                                          .foregroundColor(Color.black)
                                      
                                  }.padding(.top,10).padding(.leading,13)
                              Divider()}
                              
                              VStack(alignment: .leading) {
                                  HStack{ Text("Employee ID:").frame( alignment: .leading).foregroundColor(.gray)
                                      Text(viewModel.employeeID)
                                          .foregroundColor(Color.black)
                                      
                                  }.padding(.top,10).padding(.leading,13)
                                  Divider()  }
                              
                              VStack(alignment: .leading) {
                                  HStack{ Text("National ID:").frame( alignment: .leading).foregroundColor(.gray)
                                      Text(viewModel.nationalID)
                                          .foregroundColor(Color.black)
                                      
                                  }.padding(.top,10).padding(.leading,13)
                                  Divider() }
                              
                          }.padding(.leading,10)
                         
                          VStack{
                          HStack(alignment: .center) {
                              Text("Phone Number:")
                                  .bold().foregroundColor(.cyan)
                              TextField("Enter your Phone number...", text:$viewModel.phonemum)  .keyboardType(.numberPad)
                                  
                          }.padding(.top,11).padding(.leading,20)
                              Divider().padding(.bottom,10)
                              
                          }
                          Button(action: {
                              viewModel.UpdateData()
                              if let thisimage = self.inputImage{
                                  imageUpload(image: thisimage)
                                //  Upladimg(image:thisimage)
                              }else{
                                  print("Can not")
                              }
                              dismiss() 
                          }) {
                              HStack {
//                                  Image(systemName: "gift")
                                  Text("Update Profile")
                              }
                          }
                          .padding(15).padding(.top,0)
                          .foregroundColor(.white)
                          .background(Color.gray)
                          .cornerRadius(.infinity)
                   Spacer()   }}                      .navigationTitle("Edit Profile")
                      .navigationBarTitleDisplayMode(.inline)
                  .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                      Button(action: {
                          dismiss()                      }) {
                        Label("Send", systemImage: "chevron.left")
                      }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                      Button(action: {
                        print("Refresh")
                      }) {
                      Text("Save")
                      }
                    
                  }
                  }}.task {
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
         
            
        }.task {
            
            print("noy'")

            self.viewModel.fetchData()
           
//            Storage.storage().reference().child("Emp1").getData(maxSize: 15*1024*1024){
//                (imageDate,err) in
//                if let err = err {
//                    print("error\(err.localizedDescription)")
//                } else {
//                    if let imageData = imageDate{
//                        self.userimage = UIImage(data: imageData)
//                    }
//
//
//                else {
//
//                        print("no error")
//
//                }
//                }
//
//            }
                
            }
           // print($username)
//            $username = self.viewModel.Employeeinfolist1

        }
    }
    func imageUpload(image:UIImage){
        if let imageDate = image.jpegData(compressionQuality: 1){
            let storage = Storage.storage()
            storage.reference().child("Emp1").putData(imageDate, metadata: nil){
                (_,err) in
                if let err = err {
                    print("error\(err.localizedDescription)")
                }else{
                    print("no error")
                }
                
            }
        }
    }

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
