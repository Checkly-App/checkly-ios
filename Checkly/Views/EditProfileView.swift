//
//  EditProfileView.swift
//  Checkly
//
//  Created by  Lama Alshahrani on 10/07/1443 AH.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
       @State private var showingImagePicker = false
       @State private var inputImage: UIImage?
       @State private var userimage: UIImage?
    let userid = Auth.auth().currentUser!.uid

       @State private var showingAlert = false
       @State private var presentAlert = false
    @State var password = ""
      @State var passwordAgain = ""
      @State var error = ""
      @State var title = ""
      @State var passeroor = ""

      @State var passAgainerror = ""
   @State   var ref = Database.database().reference()


    @State private var isVisible = false
    @State private var isVisible0 = false

    @State private var Ephone = false
    @State private var Ename = false
    @State private var showingSheet = false
    @State  var selected = 1


       @ObservedObject private var viewModel = EmployeeViewModel()
       @State private var username: String = ""
       @State private var error0: String = ""
       @State private var errorname: String = ""
    

       @State private var errorphone: String = ""
    var body: some View {
        NavigationView{
            ScrollView{
            VStack{
                Button {
                  showingImagePicker = true
                                              } label: {
            if let image = self.inputImage {
                Image(uiImage: image).resizable().scaledToFill().frame(width: 137, height: 137)            .clipShape(Circle())
                
            }
                                              
                    else if let image = self.userimage{
                        Image(uiImage: image).resizable().scaledToFill().frame(width: 137, height: 137)            .clipShape(Circle())
            }
                        else {
                            Image("ProfileImage").resizable()
                                    .frame(width: 137.0, height: 137.0)
           }
                                              }.padding(.vertical).fullScreenCover(isPresented: $showingImagePicker) {
                                                  ImagePicker(image: $inputImage)
                                
                                              }.overlay(      Image("camera"),alignment: .trailing)
            }
                
                VStack(alignment:.leading){
                   // Section
                    //The name
                    Section(header: Text("Acccount Information").font(.callout)
                                .padding(.leading).padding(.bottom, 1)) {
                        VStack(alignment: .leading) {
                            Text("Employee Name")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(UIColor(named: "LightGray")!))
                            TextField("type your email", text: $viewModel.Employeeinfolist1)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding(10)
                                .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                            .stroke(Ename ?
                                            .red :
                                                        Color(UIColor(named: "Blue")!) , lineWidth: 0.5))
                                .foregroundColor(viewModel.Employeeinfolist1.isEmpty ?
                                                 Color(UIColor(named: "LightGray")!) :
                                                    Color(UIColor(named: "Blue")!))
                            Text(errorname)
                                .font(.callout)
                                .fontWeight(.light)
                                .foregroundColor(Color("Blue")).onChange(of: viewModel.Employeeinfolist1) { newValue in
                                    if (viewModel.Employeeinfolist1 == ""){
                                        errorname = "Can not be empty"
                                        Ename = true
                                    }
                                    else if
                                       (viewModel.Employeeinfolist1.count <= 2 || viewModel.Employeeinfolist1.count >= 20)
                                    {
                                        errorname = "Range of name 3-20 "
                                        Ename = true

                                    }
                                    else{
                                        errorname = " "
                                        Ename = false

                                    }
                                    
                                        //errorname = ""
                                    

                                   

                                    for str in viewModel.Employeeinfolist1 {
                                        if (!(str >= "a" && str <= "z") && !(str >= "A" && str <= "Z") && str != " " ) {
                                            errorname = "Only chatcters "
                                            Ename = true

                                           
                                        }
                                        else{
                                            errorname = " "
                                            Ename = false

                                        }
                                     }
                        }
                        }
                        .animation(.default).padding(.horizontal)
                        //Email
                        VStack(alignment: .leading) {
                            Text("Email")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(UIColor(named: "LightGray")!))
                            TextField("type your email", text: $viewModel.email).disabled(true)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .padding(10).background(.gray.opacity(0.25))
                                .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                            .stroke(.gray, lineWidth: 0.5))
                                .foregroundColor(.gray)
                        }
                        .animation(.default).padding(.horizontal)
                        VStack(alignment: .leading) {
                            Text("Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(UIColor(named: "LightGray")!))
                            HStack{
                                if !isVisible {
                                    SecureField("type your new password", text: $password)
                                }
                                else {
                                    TextField("type your new password", text: $password)
                                }
                                Button {
                                    withAnimation{
                                        isVisible.toggle()
                                    }
                                    
                                } label: {
                                    Image(systemName: isVisible ? "eye.fill" : "eye.slash.fill")
                                }
                                
                            }
                            .padding(10)
                            .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                        .stroke(password.isEmpty ?
                                                Color(UIColor(named: "LightGray")!) :
                                                    Color(UIColor(named: "Blue")!) , lineWidth: 0.5))
                            .foregroundColor(password.isEmpty ?
                                             Color(UIColor(named: "LightGray")!) :
                                                Color(UIColor(named: "Blue")!))
                            Text(passeroor)
                                .font(.callout)
                                .fontWeight(.light)
                                .foregroundColor(Color("Blue")).onChange(of: password) { newValue in
                                    if password == ""{
                                     passeroor = ""
                                 }
                                  else if (password.count <= 6)  {
                                       passeroor = "the length must be at least 7"
                                   }                         else{
                                       passeroor = ""
                                   }
                                  
                               }
                        }
                        .padding(.horizontal)
                        .animation(.default)
                        VStack(alignment: .leading) {
                            Text("Confirme Password")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(UIColor(named: "LightGray")!))
                            HStack{
                                if !isVisible0 {
                                    SecureField("type the confirme password", text: $passwordAgain)
                                }
                                else {
                                    TextField("type the confirme password", text: $passwordAgain)
                                }
                                Button {
                                    withAnimation{
                                        isVisible0.toggle()
                                    }
                                    
                                } label: {
                                    Image(systemName: isVisible0 ? "eye.fill" : "eye.slash.fill")
                                }
                                
                            }
                            .padding(10)
                            .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                        .stroke(passwordAgain.isEmpty ?
                                                Color(UIColor(named: "LightGray")!) :
                                                    Color(UIColor(named: "Blue")!) , lineWidth: 0.5))
                            .foregroundColor(passwordAgain.isEmpty ?
                                             Color(UIColor(named: "LightGray")!) :
                                                Color(UIColor(named: "Blue")!))
                            Text(passAgainerror)
                                .font(.callout)
                                .fontWeight(.light)
                                .foregroundColor(Color("Blue")).onChange(of: passwordAgain) { newValue in
                                    if passwordAgain == ""{
                                        passAgainerror = ""
                                    }
                                    else if (passwordAgain.count <= 6)  {
                                        passAgainerror = "The length must be at least 7"
                                    }else{
                                        passAgainerror = ""
                                    }
                                    if passwordAgain != password{
                                        passAgainerror = "Not match with the password"
                                    }else{
                                        passAgainerror = ""
                                    }
                                  
                                }
                        }
                        .padding(.horizontal)
                        .animation(.default)
                    }
                    // Section
                     Section(header: Text("Personal Information").font(.callout)
                                .padding(.leading).padding(.bottom, 1).padding(.top,40.0)) {
                         VStack(alignment: .leading) {
                             Text("Phone Number")
                                 .font(.system(size: 14, weight: .medium))
                                 .foregroundColor(Color(UIColor(named: "LightGray")!))
                             TextField("type your phone number", text: $viewModel.phonemum)
                                 .keyboardType(.numberPad)
                                 .autocapitalization(.none)
                                 .padding(10)
                                 .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                             .stroke(Ephone ?
                                                        .red :
                                                         Color(UIColor(named: "Blue")!) , lineWidth: 0.5))
                                 .foregroundColor(viewModel.phonemum.isEmpty ?
                                                  Color(UIColor(named: "LightGray")!) :
                                                     Color(UIColor(named: "Blue")!))
                             Text(errorphone)
                                 .font(.callout)
                                 .fontWeight(.light)
                                 .foregroundColor(Color("Blue")).onChange(of: viewModel.phonemum) { newValue in
                                     
                                     if  viewModel.phonemum == "" {
                                         errorphone = "Can not be empty"
                                         Ephone = true
                                         }
                                    else
                                         if !viewModel.phonemum.hasPrefix("05"){
                                             errorphone = "start with 05"
                                             Ephone = true

                                            }
                                    else if (viewModel.phonemum.count != 10){
                                         errorphone = "10 numbers "
                                        Ephone = true

                                                 }
                                     
                                     else {
                                         errorphone = " "
                                         Ephone = false

                                     }
                                 
                                 }

                                
                             }
                         
                         .animation(.default).padding(.horizontal)
                         
                         VStack(alignment: .leading) {
                             Text("National ID")
                                 .font(.system(size: 14, weight: .medium))
                                 .foregroundColor(Color(UIColor(named: "LightGray")!))
                             TextField("type your ID", text: $viewModel.nationalID)
                                 .disabled(true)
                                     .keyboardType(.emailAddress)
                                     .autocapitalization(.none)
                                     .padding(10).background(.gray.opacity(0.25))
                                     .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                                 .stroke(.gray, lineWidth: 0.5))
                                     .foregroundColor(.gray)
                         }
                         .animation(.default).padding(.horizontal)
                         VStack(alignment: .leading) {
                             Text("Date of Birth")
                                 .font(.system(size: 14, weight: .medium))
                                 .foregroundColor(Color(UIColor(named: "LightGray")!))
                             TextField("type your email", text: $viewModel.birth)
                                 .disabled(true)
                                     .keyboardType(.emailAddress)
                                     .autocapitalization(.none)
                                     .padding(10).background(.gray.opacity(0.25))
                                     .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                                 .stroke(.gray, lineWidth: 0.5))
                                     .foregroundColor(.gray)
                                         

                         }
                         .animation(.default).padding(.horizontal)
                         VStack(alignment: .leading) {
                             Text("Address")
                                 .font(.system(size: 14, weight: .medium))
                                 .foregroundColor(Color(UIColor(named: "LightGray")!))
                             TextField("type your ID", text: $viewModel.address)
                                 .disabled(true)
                                     .keyboardType(.emailAddress)
                                     .autocapitalization(.none)
                                     .padding(10).background(.gray.opacity(0.25))
                                     .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                                 .stroke(.gray, lineWidth: 0.5))
                                     .foregroundColor(.gray)
                         }
                         .animation(.default).padding(.horizontal)
                         
                //         VStack(alignment:.)
                         VStack(alignment:.leading){
                             Text("Gender")  .font(.system(size: 14, weight: .medium))
                                 .foregroundColor(Color(UIColor(named: "LightGray")!))
                             HStack{
                                 HStack{
                                 Circle()
                                         .fill(viewModel.gender1 ?  Color.gray.opacity(1) : Color.gray.opacity(0.25) )
                                     .frame(width:20, height: 20)
                                     Text("Male ")
                                         .fontWeight(.regular)
                             }.overlay(RoundedRectangle(cornerRadius: 5)
                                         .fill(Color.gray.opacity(0.3))
                                         .frame(width: 130, height: 55).foregroundColor(.black).border(.black, width: 0.5).cornerRadius(5)).padding()
                             HStack{
                                 Circle()
                                     .fill(viewModel.gender2 ?  Color.gray.opacity(1) : Color.gray.opacity(0.25) )
                                     .frame(width:20, height: 20)
                                 Text("Female")
                                     .fontWeight(.regular)
                             }.overlay(RoundedRectangle(cornerRadius: 5)
                                         .fill(Color.gray.opacity(0.3))
                                         .frame(width: 130, height: 55).border(.black, width: 0.5).cornerRadius(5)).padding(.leading).padding(.leading).padding(.leading)
                             }.padding(.leading)
//                             HStack{
//                                 HStack{
//                                 Circle()
//                                         .fill(viewModel.gender1 ? Color(UIColor(named: "LightGray")!).opacity(0.90):Color(UIColor(named: "LightGray")!).opacity(0.25))
//            .frame(width: 18, height: 18)
//              Text("Male")
//                                 }
//                                 HStack{
//                                 Circle()
//                                     .fill(viewModel.gender2 ? Color(UIColor(named: "LightGray")!).opacity(0.80):Color(UIColor(named: "LightGray")!).opacity(0.25))
//                                     .frame(width: 18, height: 18)
//                                 Text("Female")
//                                 }
//
//                             }
                         }
                         .padding(.leading)

                        
                     }
                    Section(header: Text("Company Information").font(.callout)
                               .padding(.leading).padding(.bottom, 1).padding(.top,40.0)) {
                        VStack(alignment: .leading) {
                            Text("Employee ID")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(UIColor(named: "LightGray")!))
                            TextField("type your ID", text: $viewModel.employeeID)
                                    .disabled(true)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .padding(10).background(.gray.opacity(0.25))
                                        .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                                    .stroke(.gray, lineWidth: 0.5))
                                        .foregroundColor(.gray)

                        }
                        .animation(.default).padding(.horizontal)
                        
                        VStack(alignment: .leading) {
                            Text("Department")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(UIColor(named: "LightGray")!))
                            TextField("type your department", text: $viewModel.department)
                                .disabled(true)
                                    .keyboardType(.emailAddress)
                                    .autocapitalization(.none)
                                    .padding(10).background(.gray.opacity(0.25))
                                    .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                                .stroke(.gray, lineWidth: 0.5))
                                    .foregroundColor(.gray)

                        }
                        .animation(.default).padding(.horizontal)
                        VStack(alignment: .leading) {
                            Text("Position")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundColor(Color(UIColor(named: "LightGray")!))
                            TextField("type your position", text: $viewModel.position)
                                    .disabled(true)
                                        .keyboardType(.emailAddress)
                                        .autocapitalization(.none)
                                        .padding(10).background(.gray.opacity(0.25))
                                        .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                                                    .stroke(.gray, lineWidth: 0.5))
                                        .foregroundColor(.gray)

                        }
                        .animation(.default).padding(.horizontal)
                       
                    }
               
                    
                }
                VStack(alignment: .trailing){
                Button {
                    if !Validation(){
                presentAlert = true
                                             
                                           }
                    
                    else{
                        if !password.isEmpty || !passwordAgain.isEmpty{
                        Auth.auth().currentUser?.updatePassword(to: password) { error in
                                             // ...
                                               print(error?.localizedDescription as Any)
                                           
                        }}
                        viewModel.UpdateData()
            if let thisimage = self.inputImage{
                imageUpload(image: thisimage)
                let randomDouble = Double.random(in: 1...100)

        self.ref.child("Employee").child(userid).updateChildValues(["ChangeImage": randomDouble ])
                                     //  Upladimg(image:thisimage)
                viewModel.Ischange = true                            }else{
                                                                       print("Can not")
                                                                   }
                                                                   dismiss()
                                           
                                               }}                  label: {
                    HStack{
                        Text("Update")
                            .foregroundColor(Color("Blue"))
                        Circle().fill(
                            LinearGradient(gradient: Gradient(colors: [
                                Color(UIColor(named: "Blue")!),
                                Color(UIColor(named: "LightTeal")!)]),
                                           startPoint: .leading, endPoint: .trailing)).frame(width: 50, height: 50).overlay(Image(systemName: "chevron.right").foregroundColor(.white)    .font(.largeTitle)
)
                        
                }.alert("Oops!..", isPresented: $presentAlert, actions: {
                    // actions
                }, message: {
                    Text(error0)
                })
                }
                }.padding().padding(.leading).padding(.leading).padding(.leading).padding(.leading).padding(.leading).padding(.leading).padding(.leading).padding(.leading).padding(.leading)

                Spacer()
            }.navigationBarTitle("Edit Profile").navigationBarTitleDisplayMode(.inline).toolbar {
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
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button("Update") {
                            if !Validation(){
                        presentAlert = true
                                                     
                                                   }
                            
                            else{
                                if !password.isEmpty || !passwordAgain.isEmpty{
                                Auth.auth().currentUser?.updatePassword(to: password) { error in
                                                     // ...
                                                       print(error?.localizedDescription as Any)
                                                   
                                }}
                                viewModel.UpdateData()
                    if let thisimage = self.inputImage{
                        
                        imageUpload(image: thisimage)
                       showingSheet = true
                                     
                        
                    }else{
                        
                                                                               print("Can not")
                                                                           }
                                if showingSheet{
                                DispatchQueue.main.asyncAfter(deadline: .now() + 4){
                                let randomDouble = Double.random(in: 1...100)

            self.ref.child("Employee").child(userid).updateChildValues(["ChangeImage": randomDouble ])
                                    showingSheet = false
                                    dismiss()
                                }
                                }
                                else {
                                    dismiss()}

                                                       }                        }
                        
                    }
            }.task{
                
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
        }.task{
            print("edit")

            print(userid)
            showingSheet = true

            self.viewModel.fetchData()
        }
       .overlay(showingSheet ? LoadingView(): nil)
        
        
    }
    func imageUpload(image:UIImage){
               if let imageDate = image.jpegData(compressionQuality: 1){
                   let storage = Storage.storage()
                   storage.reference().child(userid).putData(imageDate, metadata: nil){
                       (_,err) in
                       if let err = err {
                           print("error\(err.localizedDescription)")
                       }else{
                           print("no error")
                       }
                       
                   }
                   storage.reference().child(userid).downloadURL{url,err in
                       if let err = err {
                           print(err.localizedDescription)
                       }
                       print(url?.absoluteString)
                       self.ref.child("Employee").child(userid).updateChildValues(["tokens": url?.absoluteString ])
                       
                       
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
        if password != passwordAgain{
                    error0 = "The paswwords and the confirme password must be same"
                    return false
                }
              
                if (password.count != 0 && password.count <= 6)  {
                    error0 = "the leangth of password musr be at least 7 "

                    return false
                }
                if (passwordAgain.count != 0 && passwordAgain.count <= 6) {
                    error0 = "the leangth of password musr be at least 7 "
                    return false
                }
          
           return test
        }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView()
    }
}
