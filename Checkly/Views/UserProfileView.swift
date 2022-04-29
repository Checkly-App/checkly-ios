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
import SDWebImageSwiftUI


struct UserProfileView: View {
    let userid = Auth.auth().currentUser!.uid
   // @EnvironmentObject var settings: GameSettings
    @Environment(\.dismiss) var dismiss
    @State private var showingSheet = false
    private var ref = Database.database().reference()
    @State var user = "-MyI_ITa2ttXlgub1eBe"
     var name = ""
    @State private var userimage: UIImage?
    @ObservedObject private var viewModel = EmployeeViewModel()
    @State var toggleNotification = true
    @State var toggleLocation = true
    // for eatch view
    @State var ispresent1 = false
    @State var ispresent2 = false
    @State var ispresent3 = false
    @State  var imageURL: String = ""

//just we need if we use navihation link
//    var listName: [String] = ["Terms And Conditions", "Privacy Policy", "Edit Profile","Change Password"]
//    var listIcon: [String] = ["Terms", "privacy-1", "Editprofile","clock"]
//
//    var listDestnation=[AnyView(EditProfileView()),AnyView(EditProfileView()),AnyView(EditProfileView()),AnyView(EditProfileView())] //This helped

    var body: some View {
        NavigationView{
            ScrollView{
               
        VStack{
            //first section
            VStack(spacing:8){
               if  viewModel.tokens != "null"{
                   WebImage(url:URL(string: viewModel.tokens)).resizable().scaledToFill().frame(width: 137, height: 137)            .clipShape(Circle())

                    
                }
                
                else{
                Image("profile").resizable()
                        .frame(width: 137.0, height: 137.0)
                    
                }
                Text(viewModel.Employeeinfolist1)
                    .font(.title)
                    .fontWeight(.semibold).task {
                        showingSheet = true

                    }
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
               
        // section 2
                    
                HStack{
                    Button {
                       ispresent1 = true
                    } label: {
                    Image("terms").foregroundColor(.gray)
                    Text("Terms And Conditions")
                            .font(.body)
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
                    Image("privacy").foregroundColor(.gray)
                    Text("Privacy Policy")
                            .font(.body)
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
                    Image("edit").foregroundColor(.gray)
                    Text("Edit profile")
                            .font(.body)
                        .fontWeight(.medium).foregroundColor(.black)
Spacer()
                    
                               Image(systemName: "chevron.right").foregroundColor(.black)
                    
                    }   }.padding().fullScreenCover(isPresented: $ispresent3) {
                        EditProfileView()
                    }
                
                    
                
                Divider().padding()
               
                HStack{
                    
                    // section 3
                   
                        
                    Image("notification")
                    
                        
                           
                    Text("Notification")
                        .font(.callout)
                        .fontWeight(.medium)
                       
                    Toggle(isOn: $toggleNotification) {
                        
                    }.tint(.cyan)
                }.padding()
                HStack{
                  
                               Image("location").foregroundColor(.gray)
                           
                    Text("Location")
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
                showingSheet = false

            }.task {
// fetch image after ediiting
                ref.child("Employee").child(userid).child("image_token").observe(.value) { snapshot in
                            
                    
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
            .preferredColorScheme(.light)
        }

    }
}


struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
