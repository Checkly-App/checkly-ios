

//
//  messagesView.swift
//  messages
//
//  Created by Noura Alsulayfih on 07/07/1443 AH.
//
import SwiftUI
import Firebase
import FirebaseStorage
import SDWebImageSwiftUI



struct messagesView: View {
    
    @State var shouldNavigateToChatLogView = false
    @State var shouldShowNewMessageScreen = false
    @State var selectedUser: Employee?
    @ObservedObject var vm = messagesViewModel()
    var emp: Employee
    

    var body: some View {
        NavigationView{
            VStack {
                ScrollView {
                    ForEach(vm.recentMessages) { recentMessage in
                        
                        
                                HStack {
                                    HStack (spacing: 16){
                                        if ( recentMessage.photoURL == "null") {
                                            Image(systemName: "person.crop.circle.fill").font(.system(size:65)).foregroundColor(.gray).frame(width: 64, height: 64).clipped().cornerRadius(64).overlay(RoundedRectangle(cornerRadius: 64).stroke(Color(.gray), lineWidth: 1)).shadow(radius: 5)
                                        } else {
                                            WebImage(url: URL(string: recentMessage.photoURL)).resizable().scaledToFill().frame(width: 64, height: 64).clipped().cornerRadius(64).overlay(RoundedRectangle(cornerRadius: 64).stroke(Color(.gray), lineWidth: 1)).shadow(radius: 5)
                                        }
                                        
                                        VStack (alignment: .leading, spacing: 10){
                                            if ( recentMessage.senderName == "Dalal Bin Humaid") {
                                                Text(recentMessage.receiverName).font(.system(size: 16, weight: .bold)).foregroundColor(.black)
                                                Text(recentMessage.text).font(.system(size: 14)).foregroundColor(Color(.darkGray))
                                                    .multilineTextAlignment(.leading )
                                            } else {
                                                Text(recentMessage.senderName).font(.system(size: 16, weight: .bold)).foregroundColor(.black)
                                                Text(recentMessage.text).font(.system(size: 14)).foregroundColor(Color(.darkGray))
                                                    .multilineTextAlignment(.leading )
                                            }
                                        }
                                        Spacer()
                                        Text(recentMessage.timestamp.timeAgoDisplay()).font(.system(size: 10, weight: .semibold)).foregroundColor(.gray)
                                    }
                                    .padding()
                                }
                                .background(NavigationLink(
                                    destination: chatView(chatUser: selectedUser),
                                    isActive: $shouldNavigateToChatLogView) {
                                        EmptyView()
                                    }).contentShape(Rectangle())
                                .onTapGesture {
                                    if ( recentMessage.fromID == vm.userID ) {
                                        vm.getSelectedUser(id: recentMessage.toID, completion: { emp in
                                            selectedUser = emp
                                        })
                                    }else{
                                        vm.getSelectedUser(id: recentMessage.fromID, completion: { emp in
                                            selectedUser = emp
                                        })
                                    }
                                    shouldNavigateToChatLogView.toggle()    // << activate link !!
                                }
                        Divider()
                        
                        
                    }
                    
                    
                    VStack (alignment: .center) {
                        Text("You don't").font(.system(size: 20, weight: .heavy)).foregroundColor(Color(hexStringToUIColor(hex: "2CAFEE")))
                        Text("have any messages yet!").font(.system(size: 17)).foregroundColor(.gray)
                    }.offset(y: 300)
                        .opacity(vm.recentMessages.count == 0 ? 1 : 0 )
                    
                }
                
                
                
                .navigationTitle("Messages").navigationBarTitleDisplayMode(.inline)
                NavigationLink("" , isActive: $shouldNavigateToChatLogView) {
                    chatView(chatUser: self.selectedUser)
                }
                Button {
                    shouldShowNewMessageScreen.toggle()
                } label: {
                    HStack{
                        Spacer()
                        Text("+ New Message").font(.system(size: 16, weight: .bold))
                        Spacer()
                    }.foregroundColor(.white)
                        .padding(.vertical)
                        .background(LinearGradient(gradient: Gradient(colors: [Color(hexStringToUIColor(hex: "58BCEC")), Color(hexStringToUIColor(hex: "439FF3"))]), startPoint: .leading, endPoint: .trailing))
                        .cornerRadius(32)
                        .padding(.horizontal)
                        .shadow(radius: 15)
                }.fullScreenCover(isPresented: $shouldShowNewMessageScreen, onDismiss: nil) {
                    createNewMessageView(didSelectNewUser: {
                        user in
                        self.shouldNavigateToChatLogView.toggle()
                        self.selectedUser = user
                    })
                }
            }
        }
    }

}


extension Date {
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
}



struct messagesView_Previews: PreviewProvider {
    
    static let employee = Employee(address: "", birthdate: "", department: "", email: "", id: "", gender: "", name: "", national_id: "", phone_number:  "", position: "", photoURL: "")
    
    static var previews: some View {
        messagesView(emp: employee)
    }
}
