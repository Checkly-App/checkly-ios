//
//  UserProfile.swift
//  Scheak
//
//  Created by  Lama Alshahrani on 01/07/1443 AH.
//

import SwiftUI
import Firebase
import FirebaseDatabase
import FirebaseStorage


struct UserProfile: View {
    @Environment(\.dismiss) var dismiss
    @State private var showingSheet = false

    @State var user = ""
     var name = ""
    @State private var userimage: UIImage?


    @ObservedObject private var viewModel = EmployeeViewModel()

    @State var employeeName = ""
    var body: some View {
        VStack{
          
            HStack {
                Button {
                    dismiss()

                } label: {
                    Image(systemName: "chevron.left").font(.system(size: 25.0)).foregroundColor(.gray)
            }.padding(.trailing,270)
                Button {
                    showingSheet.toggle()
                

                } label: {
                    Image(systemName: "square.and.pencil").font(.system(size: 30.0)).foregroundColor(.gray)
                }.padding(.trailing,1).fullScreenCover(isPresented: $showingSheet) {
EditProfileView()                }
            }
            
            
            VStack {
//                Image(systemName: "person.circle.fill")
//                                                                                                                                                                                                            .foregroundColor(.white)
//                                                                                                                                                                                                        .imageScale(.large).font(.system(size: 100.0)).padding(.top,10)
                
                if let image = self.userimage{
                    Image(uiImage: image).resizable().scaledToFill().frame(width: 128, height: 128).cornerRadius(70)
                }else{
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.white)
                    .imageScale(.large).font(.system(size: 100.0)).padding(.top,13)}
            }.padding(.trailing,1)
    .task {
                
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
            Text(viewModel.Employeeinfolist1).fontWeight(.semibold).foregroundColor(Color(hue: 1.0, saturation: 0.015, brightness: 0.345)).padding(.top,0)
            Text("\(viewModel.position)")
                .fontWeight(.regular).foregroundColor(.gray).padding(.top,0.2)
            Text("\(viewModel.department)")
                .fontWeight(.regular).foregroundColor(.gray).padding(.top,0.2)
            
            ZStack{
                
                VStack(alignment: .leading,spacing: 10){
                    
                    HStack{ Text("Email:").frame( alignment: .leading).foregroundColor(.gray)
                        Text(viewModel.email)
                            .foregroundColor(Color.black)
                        
                        
                    }.padding(.top,50)
                    
                 
                   
                    HStack{ Text("Gender:").frame( alignment: .leading).foregroundColor(.gray)
                        Text(viewModel.gender)
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,20)
                    HStack{ Text("Address:").frame( alignment: .leading).foregroundColor(.gray)
                        Text(viewModel.address)
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,20)
                    HStack{ Text("Birth Date:").frame( alignment: .leading).foregroundColor(.gray)
                        Text(viewModel.birth)
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,20)
                    HStack{ Text("Employee ID:").frame( alignment: .leading).foregroundColor(.gray)
                        Text(viewModel.employeeID)
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,20)
                    HStack{ Text("National ID:").frame( alignment: .leading).foregroundColor(.gray)
                        Text(viewModel.nationalID)
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,20)
                    HStack{ Text("Phone Number:").frame( alignment: .leading).foregroundColor(.gray)
                        Text(viewModel.phonemum)
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,20)
Spacer()
                }.frame( alignment: .leading).padding(.leading,-145)
                
                
                
            }.frame( maxWidth: .infinity,  maxHeight: .infinity).background(.white).cornerRadius(30).padding(.top,35).shadow(radius: 4.0)
            Spacer() }.frame( maxWidth: .infinity,  maxHeight: .infinity).background( LinearGradient(gradient: Gradient(colors: [Color(red: 207/255, green: 242/255, blue: 242/255), Color(red: 210/255, green: 236/255, blue: 249/255)]), startPoint: .top, endPoint: .bottom)).task {
                self.viewModel.fetchData()

            }

                //read()
                
                
                
            }

                                                                         
            
    
}


struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        
        UserProfile()
.previewInterfaceOrientation(.portraitUpsideDown)
    }
}
