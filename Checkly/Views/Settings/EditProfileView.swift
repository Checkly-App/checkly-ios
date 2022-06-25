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
import SDWebImageSwiftUI

struct EditProfileView: View {
    // MARK: - @State, @Environment, @ObservedObject
    @State var isNameError = false
    @State var isVisible = false
    @State var isVisible0 = false
    @State var Ephone = false
    
    @State var employeeNameError: String = ""
    @State var error = ""
    @State var passeroor = ""
    @State var passAgainerror = ""
    
    @State var presentAlert = false
    @State var password = ""
    @State var passwordAgain = ""
    @State var title = ""
    @State var showingSheet = false
    @State var selected = 1
    @State var username: String = ""
    @State var error0: String = ""
    @State var errorphone: String = ""
    @State var showingImagePicker = false
    @State var inputImage: UIImage?
    @State var userimage: UIImage?
    @State var progress: Float = 0.0
    @State var degree: Double = 270
    @ObservedObject  var employeeViewModel = EmployeeViewModel()
    @Environment(\.dismiss) var dismiss
    
    // MARK: - Variables
    let userid = Auth.auth().currentUser!.uid
    let ref = Database.database().reference()
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ScrollView {
                ZStack {
                    CircularProgressView(progress: $progress, degree: $degree)
                        .frame(width: 138, height: 138, alignment: .center)
                    Button {
                        showingImagePicker = true
                    } label: {
                        ZStack(alignment: .topTrailing){
                            if let image = self.inputImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 128, height: 128)
                                    .clipShape(Circle())
                            }
                            else if employeeViewModel.tokens != "null"{
                                WebImage(url:URL(string: employeeViewModel.tokens))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 128, height: 128)
                                    .clipShape(Circle())
                            }
                            else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 128, height: 128)
                                    .foregroundColor(Color("light-gray"))
                            }
                            Image("camera")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                        }
                    }
                    .padding(.vertical)
                    .fullScreenCover(isPresented: $showingImagePicker) {
                        ImagePicker(image: $inputImage)
                    }
                }
                .onReceive(timer) { time in
                    degree += 10
                    if (progress > 1.0) {
                        progress = 0
                    }
                    else {
                        progress += 0.01
                    }
                }
                
                VStack(alignment:.leading){
                    Section(header: Text("Acccount Information")
                                .font(.callout)
                                .padding(.leading)
                                .padding(.bottom, 1)) {
                        SectionInputView(error: $employeeNameError, text: $employeeViewModel.employeeName, placeHolder: "typer your name", title: "Employee Name", validation: { validateName() })
                        DisabledSectionInputView(text: $employeeViewModel.email, placeHolder: "typer your email", title: "Email")
                        PasswordSectionInputView(error: $passeroor, text: $password, isVisible: $isVisible, placeHolder: "typer your password", title: "Password",validation: {validatePassword()} )
                        PasswordSectionInputView(error: $passAgainerror,text: $passwordAgain,isVisible: $isVisible0,placeHolder: "typer your password again", title: "Confirm Password", validation: { validateConfirmPassword() })
                    }
                    Section(header: Text("Personal Information")
                                .font(.callout)
                                .padding(.leading)
                                .padding(.bottom, 1)
                                .padding(.top,40.0)) {
                        SectionInputView(error: $errorphone, text: $employeeViewModel.phonemum, placeHolder: "typer your phone number", title: "Phone Number", validation: { validatePhone() })
                        DisabledSectionInputView(text: $employeeViewModel.nationalID, placeHolder: "type your ID", title: "National ID")
                        DisabledSectionInputView(text: $employeeViewModel.birth, placeHolder: "type your Date of Birth", title: "Date of Birth")
                        DisabledSectionInputView(text: $employeeViewModel.address, placeHolder: "type your address", title: "Address")
                        
                        GenderView(male: employeeViewModel.gender1, female: employeeViewModel.gender2)
                        
                        Section(header: Text("Company Information")
                                    .font(.callout)
                                    .padding(.leading)
                                    .padding(.bottom, 1)
                                    .padding(.top,40.0)) {
                            DisabledSectionInputView(text: $employeeViewModel.employeeID, placeHolder: "type your ID", title: "Employee ID")
                            DisabledSectionInputView(text: $employeeViewModel.department, placeHolder: "type your department", title: "Department")
                            DisabledSectionInputView(text: $employeeViewModel.position, placeHolder: "type your position", title: "Position")
                        }
                    }
                                        
                }
                .navigationBarTitle("Edit Profile").navigationBarTitleDisplayMode(.inline).toolbar {
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
                        Button("Save") {
                            if !Validation(){
                                presentAlert = true
                                
                            }
                            
                            else{
                                if !password.isEmpty || !passwordAgain.isEmpty{
                                    Auth.auth().currentUser?.updatePassword(to: password) { error in
                                        // ...
                                        print(error?.localizedDescription as Any)
                                        
                                    }}
                                employeeViewModel.UpdateData()
                                if let thisimage = self.inputImage{
                                    
                                    imageUpload(image: thisimage)
                                    showingSheet = true
                                    
                                    
                                }else{
                                }
                                if showingSheet{
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2){
                                        let randomDouble = Double.random(in: 3...100)
                                        
                                        showingSheet = false
                                        dismiss()
                                    }
                                }
                                else {
                                    dismiss()}
                            }
                            
                        }
                    }
                    
                    
                }.task{
                    
                    Storage.storage().reference().child("/Employees/\(userid)").getData(maxSize: 15*1024*1024){
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
                showingSheet = true
                self.employeeViewModel.fetchData()
                showingSheet = false
            }
            .overlay(showingSheet ? LoadingView(): nil)
            .preferredColorScheme(.light)
            
        }
        .padding()
    }
    
    // MARK: - validateName() -> Void
    func validateName(){
        if (employeeViewModel.employeeName == ""){
            employeeNameError = "Can not be empty"
            isNameError = true
        } else if (employeeViewModel.employeeName.count <= 2 || employeeViewModel.employeeName.count >= 20){
            employeeNameError = "Range of name 3-20 "
            isNameError = true
        } else{
            employeeNameError = ""
            isNameError = false
        }
        
        for str in employeeViewModel.employeeName{
            if (!(str >= "a" && str <= "z") && !(str >= "A" && str <= "Z") && str != " " ) {
                employeeNameError = "Only chatcters "
                isNameError = true
            } else{
                employeeNameError = ""
                isNameError = false
            }
        }
    }
    
    func validatePassword() -> Void{
        if password == "" {
            passeroor = ""
            
        } else if (password.count <= 6)  {
            passeroor = "the length must be at least 7"
            
        } else {
            passeroor = ""
        }
    }
    
    func validateConfirmPassword() -> Void{
        if passwordAgain == ""{
            passAgainerror = ""
        }
        else if (passwordAgain.count <= 6)  {
            passAgainerror = "The length must be at least 7"
        } else{
            passAgainerror = ""
        }
        if passwordAgain != password{
            passAgainerror = "Not match with the password"
        }else{
            passAgainerror = ""
        }
        
    }
    
    func validatePhone() -> Void {
        if  employeeViewModel.phonemum == "" {
            errorphone = "Can not be empty"
            Ephone = true
        }
        else
            if !employeeViewModel.phonemum.hasPrefix("05"){
                errorphone = "start with 05"
                Ephone = true
                
            }
        else if (employeeViewModel.phonemum.count != 10){
            errorphone = "10 numbers "
            Ephone = true
            
        }
        
        else {
            errorphone = " "
            Ephone = false
            
        }
    }
    
    // for upload image
    func imageUpload(image:UIImage){
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpg"
        if let imageDate = image.jpegData(compressionQuality: 1){
            let storage = Storage.storage()
            storage.reference().child("/Employees/\(userid)").putData(imageDate, metadata: metaData){
                (_,err) in
                if let err = err {
                    print("error\(err.localizedDescription)")
                }else{
                    print("no error")
                    storage.reference().child("/Employees/\(userid)").downloadURL{url,err in
                        if let err = err {
                            print(err.localizedDescription)
                        }
                        if (url != nil){
                            print(url?.absoluteString)
                            self.ref.child("Employee").child(userid).updateChildValues(["image_token": url?.absoluteString ])
                            
                        }
                    }
                }
                
            }
            
        }
    }
    // function validation
    func Validation() -> Bool {
        let test = true
        //var leangth = viewModel.phonemum.
        if  employeeViewModel.phonemum == "" {
            error0 = "All fields are required"
            return false}
        if  employeeViewModel.employeeName == "" {
            error0 = "All fields are required"
            return false}
        if !employeeViewModel.phonemum.hasPrefix("05"){
            error0 = "The phone number must start with 05"
            
            return false}
        if (employeeViewModel.phonemum.count != 10){
            error0 = "The phone number must be numbers"
            return false }
        if (employeeViewModel.employeeName.count <= 2 || employeeViewModel.employeeName.count >= 20){
            error0 = "The name must be from 3-20 characters "
            return false }
        /// validation of name
        //var str = viewModel.Employeeinfolist1
        for str in employeeViewModel.employeeName {
            if (!(str >= "a" && str <= "z") && !(str >= "A" && str <= "Z") && str != " " ) {
                error0 = "The name must contain characters only"
                
                return false
            }
        }
        if password != passwordAgain{
            error0 = "The new password and the confirm password must be the same"
            return false
        }
        
        if (password.count != 0 && password.count <= 6)  {
            error0 = "the length of password must be at least 7 "
            
            return false
        }
        if (passwordAgain.count != 0 && passwordAgain.count <= 6) {
            error0 = "the length of password must be at least 7 "
            return false
        }
        
        return test
    }
    
}
struct SectionInputView: View{
    @Binding var error: String
    @Binding var text: String
    
    var placeHolder: String
    var title: String
    var validation: () -> Void
    
    var body: some View{
        VStack(alignment: .leading) {
            //            if password {
            //                PasswordInputView(password: $text, isVisible: $isVisible)
            //            } else {
            TextInputView(text: $text, title: title, placeHolder: placeHolder)
            //            }
            Text(error)
                .font(.callout)
                .fontWeight(.light)
                .foregroundColor(.accentColor)
                .onChange(of: text) { newValue in
                    validation()
                }
        }
        .padding(.horizontal)
        .animation(.default)
    }
    
}

struct PasswordSectionInputView: View{
    @Binding var error: String
    @Binding var text: String
    @Binding var isVisible: Bool
    
    
    var placeHolder: String
    var title: String
    var validation: () -> Void
    
    var body: some View{
        VStack(alignment: .leading) {
            PasswordInputView(password: $text, isVisible: $isVisible, title: title, placeHolder: placeHolder)
            Text(error)
                .font(.callout)
                .fontWeight(.light)
                .foregroundColor(.accentColor)
                .onChange(of: text) { newValue in
                    validation()
                }
        }
        .padding(.horizontal)
        .animation(.default)
    }
    
}

struct DisabledSectionInputView: View{
    @Binding var text: String
    var placeHolder: String
    var title: String
    
    var body: some View{
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("light-gray"))
            TextField(placeHolder, text: $text)
                .disabled(true)
                .padding(10)
                .background(.gray.opacity(0.25))
                .overlay(RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .stroke(Color("light-gray"), lineWidth: 0.5))
                .foregroundColor(Color("light-gray"))
        }
        .padding(.horizontal)
    }
}

struct GenderView: View {
    var male: Bool
    var female: Bool
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Gender")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(Color("light-gray"))
            HStack {
                ZStack {
                    RoundedRectangle(cornerRadius:10)
                        .fill(Color.gray.opacity(0.25))
                        .frame(width: UIScreen.main.bounds.width*0.45, height: 55)
                    HStack {
                        Circle()
                            .fill(male ?  Color.gray.opacity(1) : Color.gray.opacity(0.25) )
                            .frame(width:20, height: 20)
                        Text("Male")
                            .fontWeight(.regular)
                    }
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.25))
                        .frame(width: UIScreen.main.bounds.width*0.45, height: 55)
                    HStack {
                        Circle()
                            .fill(female ?  Color.gray.opacity(1) : Color.gray.opacity(0.25) )
                            .frame(width:20, height: 20)
                        Text("Female")
                            .fontWeight(.regular)
                    }
                }
            }
        }
        .padding()
    }
}
