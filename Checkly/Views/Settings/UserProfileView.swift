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
    // MARK: - @State, @StateObject, @ObservedObject
    @State var userimage: UIImage?
    @State var showTermsAndConditions = false
    @State var showPrivacyPolicy = false
    @State var showEditProfile = false
    @State var imageURL: String = ""
    @State var showingSheet = false
    @State var progress: Float = 0.0
    @State var degree: Double = 270
    @StateObject private var session: Session = Session()
    @ObservedObject private var employeeViewModel = EmployeeViewModel()
    
    // MARK: - Variables
    let ref = Database.database().reference()
    let userid = Auth.auth().currentUser!.uid
    let timer = Timer.publish(every: 0.2, on: .main, in: .common).autoconnect()
    
    // MARK: - @AppStorage
    @AppStorage("isLoggedIn") var isLoggedIn = true
    @AppStorage("isSignedOut") var isSignedOut = false
    
    var body: some View {
        NavigationView{
            ZStack{
                VStack{
                    VStack(spacing:8){
                        ZStack {
                            CircularProgressView(progress: $progress, degree: $degree)
                                .frame(width: 138, height: 138, alignment: .center)
                            if  employeeViewModel.tokens != "null"{
                                WebImage(url:URL(string: employeeViewModel.tokens))
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 128, height: 128)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .frame(width: 128, height: 128)
                                    .foregroundColor(Color("light-gray"))
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
                        Text(employeeViewModel.employeeName)
                            .font(.title)
                            .fontWeight(.semibold).task {
                                showingSheet = true
                            }
                        Text("\(employeeViewModel.department) Department")
                            .font(.body)
                            .fontWeight(.semibold)
                            .foregroundColor(Color.gray)
                        Text(employeeViewModel.position)
                            .font(.body)
                            .fontWeight(.medium)
                            .foregroundColor(.accentColor)
                    }
                    .padding(.top, 32)
                    
                    // MARK: - Card
                    VStack{
                        MenuItem(showView: $showTermsAndConditions, imageName: "terms", title: "Terms And Conditions")
                            .padding()
                            .fullScreenCover(isPresented: $showTermsAndConditions) {
                                ContentView()// Change with Terms And Conditions noura
                            }
                        MenuItem(showView: $showPrivacyPolicy, imageName: "privacy", title: "Privacy Policy")
                            .padding()
                            .fullScreenCover(isPresented: $showPrivacyPolicy) {
                                ContentView()// Change with Privacy Policy noura
                            }
                        MenuItem(showView: $showEditProfile, imageName: "edit", title: "Edit profile")
                            .padding()
                            .fullScreenCover(isPresented: $showEditProfile) {
                                EditProfileView()
                            }
                    }
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 2)
                    .padding(32)
                    Spacer()
                    VStack{
                        HStack{
                            Button {
                                session.signOutUser { success in
                                    isLoggedIn = !success
                                    isSignedOut = success
                                }
                            } label: {
                                Text("Log out")
                                    .font(.body)
                                    .fontWeight(.medium)
                                    .foregroundColor(.black)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.black)
                            }
                        }
                        .padding()
                    }
                    .background(.white)
                    .cornerRadius(20)
                    .shadow(color: .black.opacity(0.15), radius: 5, x: 0, y: 2)
                    .padding(32)
                }
                .navigationBarTitle("Settings")
                .navigationBarTitleDisplayMode(.inline)
                .background(Color(red: 236, green: 236, blue: 236))
            }
            .overlay(showingSheet ? LoadingView(): nil).task {
                
                showingSheet = true
                employeeViewModel.fetchData()
                showingSheet = false
            }
            .task {
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
                        }
                        showingSheet = false
                    }
                }
            }
            .preferredColorScheme(.light)
        }
        
    }
}

// MARK: - MenuItem View
struct MenuItem: View{
    // MARK: - @Binding
    @Binding var showView: Bool
    
    // MARK: - Variables
    var imageName: String
    var title: String
    
    var body: some View{
        HStack{
            Button {
                showView = true
            } label: {
                Image(imageName)
                    .foregroundColor(.gray)
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
            }
        }
    }
}

