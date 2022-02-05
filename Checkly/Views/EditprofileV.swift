//
//  EditprofileV.swift
//  Checkly
//
//  Created by  Lama Alshahrani on 04/07/1443 AH.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseStorage


  
struct EditprofileV: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var userimage: UIImage?


    @ObservedObject private var viewModel = EmployeeViewModel()
    @State private var username: String = ""

    var body: some View {
        VStack{
            Button {
                        print("Image tapped!")
                    } label: {
                        Image(systemName:"chevron.left").foregroundColor(.cyan)
                    }.padding(.trailing,350).padding()
            
            
            Text("Edit Profile ").font(.largeTitle).fontWeight(.light).foregroundColor(Color.gray).padding(.top,20).padding(.trailing,200)
            Button {
                                       showingImagePicker = true
           
           
           
                                   } label: {
                                       if let image = self.inputImage{
                                           Image(uiImage: image).resizable().scaledToFill().frame(width: 150, height: 150).cornerRadius(80)
                                       }else {if let image = self.userimage{
                                           Image(uiImage: image).resizable().scaledToFill().frame(width: 150, height: 150).cornerRadius(70).padding()
                                       }else{
                                           Image(systemName: "person.circle.fill")
                                           .imageScale(.large).foregroundColor(Color.gray).font(.system(size: 100.0)).padding(.top,0)}}
                                   }.padding(.trailing,125).fullScreenCover(isPresented: $showingImagePicker) {
                                       ImagePicker(image: $inputImage)
                     
                               }.padding(.leading,130)
            VStack{
                VStack {
                    TextField("Enter Your Name", text:$viewModel.Employeeinfolist1)
                        .padding(.leading,20).padding(.trailing,20).padding(.top,0).foregroundColor(.cyan)
                    Rectangle()
                        .frame(height: 1.0, alignment: .bottom).padding(.leading,20).padding(.trailing,25)
                                    
                                    .foregroundColor(Color.cyan)
                    TextField("Enter Your phone", text:$viewModel.phonemum)
                        .padding(.leading,20).padding(.trailing,20).padding(.top,10).foregroundColor(.cyan)
                    
                    Rectangle()
                        .frame(height: 1.0, alignment: .bottom).padding(.leading,20).padding(.trailing,25)
                                    
                                    .foregroundColor(Color.cyan)
                   
                }
           
                VStack(alignment: .leading){
                    Text(viewModel.email).padding(.leading,25).foregroundColor(.gray)
                    Rectangle()
                        .frame(height: 1.0, alignment: .bottom).padding(.leading,20).padding(.trailing,25)
                                    
                                    .foregroundColor(Color.gray)
                    Text(viewModel.gender).padding(.leading,25).foregroundColor(.gray)
                    Rectangle()
                        .frame(height: 1.0, alignment: .bottom).padding(.leading,20).padding(.trailing,25)
                                    
                                    .foregroundColor(Color.gray)
                    Text(viewModel.birth).padding(.leading,25).foregroundColor(.gray)
                    Rectangle()
                        .frame(height: 1.0, alignment: .bottom).padding(.leading,20).padding(.trailing,25)
                                    
                                    .foregroundColor(Color.gray)
                    Text(viewModel.nationalID).padding(.leading,25).foregroundColor(.gray)
                    Rectangle()
                        .frame(height: 1.0, alignment: .bottom).padding(.leading,20).padding(.trailing,25)
                                    
                                    .foregroundColor(Color.gray)
                   
                }
                
                Spacer()
                
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
                        .fontWeight(.bold)
                        .foregroundColor(Color.white)
                }
            }
            .padding(17).padding(.leading,1)
            .foregroundColor(.white)
            .background(LinearGradient(gradient: Gradient(colors: [Color(red: 107/255, green: 200/255, blue: 244/255), Color(red: 104/255, green: 215/255, blue: 231/255)]), startPoint: .top, endPoint: .bottom))
            .cornerRadius(.infinity)

        
            
    
            Spacer()
        }.task {
            viewModel.fetchData()
        }.task {
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
    
  
}


   


struct EditprofileV_Previews: PreviewProvider {
    static var previews: some View {
        EditprofileV()
    }
}
