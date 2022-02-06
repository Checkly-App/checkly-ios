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

    @State private var showingAlert = false
    @State private var presentAlert = false

    @ObservedObject private var viewModel = EmployeeViewModel()
    @State private var username: String = ""
    @State private var error0: String = ""
    @State private var errorname: String = ""
    @State private var errorphone: String = ""



    var body: some View {
        VStack{
            VStack{
            Button {
dismiss()                    } label: {
    Image(systemName:"chevron.left").foregroundColor(.gray)
}.padding(.trailing,350).padding(.top,50)
            
            
            Text("Edit Profile ").font(.largeTitle).fontWeight(.light).foregroundColor(Color.gray).padding(.top,20).padding(.trailing,200)
            Button {
                                       showingImagePicker = true
           
           
           
                                   } label: {
                                       if let image = self.inputImage{
                                           Image(uiImage: image).resizable().scaledToFill().frame(width: 170, height: 190).clipShape(Circle())
                                       }else {if let image = self.userimage{
                                           Image(uiImage: image).resizable().scaledToFill().frame(width: 220, height: 190).padding().clipShape(Circle())
                                       }else{
                                           Image(systemName: "person.circle.fill")
                                           .imageScale(.large).foregroundColor(Color.gray).font(.system(size: 140.0)).padding(.top,0)}}
                                   }.padding(.trailing,125).fullScreenCover(isPresented: $showingImagePicker) {
                                       ImagePicker(image: $inputImage)
                     
                               }.padding(.leading,130)
            }.background(LinearGradient(gradient: Gradient(colors: [Color(red: 207/255, green: 242/255, blue: 242/255), Color(red: 210/255, green: 236/255, blue: 249/255)]), startPoint: .top, endPoint: .bottom)).cornerRadius(50).ignoresSafeArea(.all)
                VStack{
                VStack {
                    TextField("Enter Your Name", text:$viewModel.Employeeinfolist1)
                        .padding(.leading,20).padding(.trailing,20).padding(.top,10).foregroundColor(.cyan)
                    Rectangle()
                        .frame(height: 1.0, alignment: .bottom).padding(.leading,20).padding(.trailing,25)
                                    
                                    .foregroundColor(Color.cyan)
                    Text(errorname).font(.subheadline).fontWeight(.light).foregroundColor(Color.cyan).padding(.leading,250) .onChange(of: viewModel.Employeeinfolist1) { newValue in
                        if (viewModel.Employeeinfolist1 == ""){
                            errorname = "Can not be empty"
                            
                        }
                        else if 
                           (viewModel.Employeeinfolist1.count <= 2 || viewModel.Employeeinfolist1.count >= 20)
                        {
                            errorname = "Range of name 3-20 "
                            
                        }
                        else{
                            errorname = " "
                        }
                        
                            //errorname = ""
                        

                       

                        for str in viewModel.Employeeinfolist1 {
                            if (!(str >= "a" && str <= "z") && !(str >= "A" && str <= "Z") && str != " " ) {
                                errorname = "Only chatcters "

                               
                            }
                            else{
                                errorname = " "
                            }
                         }
                        
                        
                    
                    
                    }
                    TextField("Enter Your phone", text:$viewModel.phonemum)
                        .padding(.leading,20).padding(.trailing,20).padding(.top,0).foregroundColor(.cyan)
                    
                    Rectangle()
                        .frame(height: 1.0, alignment: .bottom).padding(.leading,20).padding(.trailing,25)
                                    
                                    .foregroundColor(Color.cyan)
                    Text(errorphone).font(.subheadline).fontWeight(.light).foregroundColor(.cyan).padding(.leading,200).onChange(of: viewModel.phonemum) { newValue in
                 
                        if  viewModel.phonemum == "" {
                            errorphone = "Can not be empty"
                            }
                       else
                            if !viewModel.phonemum.hasPrefix("05"){
                                errorphone = "start with 05"

                               }
                       else if (viewModel.phonemum.count != 10){
                            errorphone = "10 numbers "
                                    }
                        
                        else {
                            errorphone = " "
                        }
                    
                    }

                   
                }
           
                VStack(alignment: .leading){
                    Text(viewModel.email).padding(.leading,25).foregroundColor(.gray).padding(.top,1)
                    Rectangle()
                        .frame(height: 1.0, alignment: .bottom).padding(.leading,20).padding(.trailing,25)
                                    
                                    .foregroundColor(Color.gray)
                    Text(viewModel.gender).padding(.leading,25).foregroundColor(.gray).padding(.top,10)
                    Rectangle()
                        .frame(height: 1.0, alignment: .bottom).padding(.leading,20).padding(.trailing,25)
                                    
                                    .foregroundColor(Color.gray)
                    Text(viewModel.birth).padding(.leading,25).foregroundColor(.gray).padding(.top,10)
                    Rectangle()
                        .frame(height: 1.0, alignment: .bottom).padding(.leading,20).padding(.trailing,25)
                                    
                                    .foregroundColor(Color.gray)
                    Text(viewModel.nationalID).padding(.leading,25).foregroundColor(.gray).padding(.top,10)
                    Rectangle()
                        .frame(height: 1.0, alignment: .bottom).padding(.leading,20).padding(.trailing,25)
                                    
                                    .foregroundColor(Color.gray)
                   
                }
                    
                    VStack {
                        Button(action: {
                        if !Validation(){
                            presentAlert = true
                          
                        }
                            else{                       viewModel.UpdateData()
                                                if let thisimage = self.inputImage{
                                                    imageUpload(image: thisimage)
                                                  //  Upladimg(image:thisimage)
                                                }else{
                                                    print("Can not")
                                                }
                                                dismiss()
                        
                            }}) {
                        HStack {
        //                                  Image(systemName: "gift")
                            Text("Update Profile")
                                .fontWeight(.bold)
                                .foregroundColor(Color.white)
                        }
                    }
                            .padding()
                    .foregroundColor(.white)
                    .background(LinearGradient(gradient: Gradient(colors: [Color(red: 107/255, green: 200/255, blue: 244/255), Color(red: 104/255, green: 215/255, blue: 231/255)]), startPoint: .top, endPoint: .bottom))
                .cornerRadius(.infinity)
                    }.alert("Oops!..", isPresented: $presentAlert, actions: {
                        // actions
                    }, message: {
                        Text(error0)
                    })
                
                Spacer()
                
            }
            
            
    
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
    func Validation() -> Bool {
       let test = true
        //var leangth = viewModel.phonemum.
        if  viewModel.phonemum == "" {
            error0 = "All feilds are requierd"
            return false}
        if  viewModel.Employeeinfolist1 == "" {
            error0 = "All feilds are requierd"
            return false}
            if !viewModel.phonemum.hasPrefix("05"){
                error0 = "The phone number must be start with 05"

                return false}
        if (viewModel.phonemum.count != 10){
            error0 = "The phone number must be numbers"
                    return false }
        if (viewModel.Employeeinfolist1.count <= 2 || viewModel.Employeeinfolist1.count >= 20){
            error0 = "The name must be from 3-20 charchtrts "
                    return false }
        /// validation of name
        //var str = viewModel.Employeeinfolist1

        for str in viewModel.Employeeinfolist1 {
            if (!(str >= "a" && str <= "z") && !(str >= "A" && str <= "Z") && str != " " ) {
                error0 = "The name must contain charchters only"

               return false
            }
         }
      
       return test
    }
    
  
}


struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
