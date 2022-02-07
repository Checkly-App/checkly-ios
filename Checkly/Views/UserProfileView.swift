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




struct UserProfileView: View {
    
    @Environment(\.dismiss) var dismiss
    @State private var showingSheet = true

    @State var user = ""
     var name = ""
    @State private var userimage: UIImage?


    @ObservedObject private var viewModel = EmployeeViewModel()
    @State var toggleNotification = true
    @State var toggleLocation = true

    var songs: [String] = ["Terms And Conditions", "Privacy Policy", "Edit Profile","Change Password"]
    var songs1: [String] = ["Turn Off Notification", "Disable Location"]


    var body: some View {
        NavigationView{
            ScrollView{
        VStack{
            VStack(spacing:8){
                if let image = self.userimage{
                    Image(uiImage: image).resizable().scaledToFill().frame(width: 137, height: 137)            .clipShape(Circle())

                    
                }else{
                Image("ProfileImage").resizable()
                        .frame(width: 137.0, height: 137.0)
                    
                }
                Text(viewModel.Employeeinfolist1)
                    .font(.title)
                    .fontWeight(.semibold)
                Text(viewModel.department)
                    .font(.subheadline)
                    .fontWeight(.semibold)
               
                    .foregroundColor(Color.gray)
                Text(viewModel.position)
                    .font(.body)
                    .fontWeight(.semibold)
                    .foregroundColor(Color.cyan)
                Spacer()
                
            }.padding().padding()
            VStack{

                ForEach(songs, id: \.self) { song in
                    NavigationLink(destination: ChangePasswordView()) {
                        
                    
                HStack{
                    Image(systemName: "bell.fill").foregroundColor(.gray)
                    Text(song)
                        .font(.headline)
                        .fontWeight(.regular).foregroundColor(.black)
Spacer()
                    Button {
                               print("Image tapped!")
                           } label: {
                               Image(systemName: "chevron.right").foregroundColor(.black)
                           }                }.padding() }
                    
                }
                Divider().padding()
               
                HStack{
                    
                               Image(systemName: "bell.fill").foregroundColor(.gray)
                           
                    Text("Turn Off Notification")
                        .font(.body)
                        .fontWeight(.regular)
Spacer()
                    Toggle(isOn: $toggleNotification) {
                        
                    }.tint(.cyan)
               }.padding()
                HStack{
                  
                               Image(systemName: "location.north.fill").foregroundColor(.gray)
                           
                    Text("Disable Location")
                        .font(.body)
                        .fontWeight(.regular)
Spacer()
                    Toggle(isOn: $toggleLocation) {
                        
                    }.tint(.cyan)
               }.padding()
                Spacer()

            }.background(.white).cornerRadius(20).shadow(radius: 9).padding()
        }.navigationBarTitle("Profile").navigationBarTitleDisplayMode(.inline).background(Color(red: 236, green: 236, blue: 236)
)

        }.task {
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
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
