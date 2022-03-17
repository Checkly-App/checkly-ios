

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
    var emp: Employee
    
    init (emp: Employee) {
        self.emp = emp
        self.vm = .init(emp: emp)
    }
    
    @ObservedObject var vm: messagesViewModel

    var body: some View {
        NavigationView{
            VStack {
                ScrollView {
                    ForEach(vm.recentMessages) { recentMessage in
                        
                        
                                HStack {
                                    HStack (spacing: 10){
                                        if ( recentMessage.photoURL == "null") {
                                            Image(systemName: "person.crop.circle.fill").font(.system(size:60)).foregroundColor(.gray).frame(width: 64, height: 64).clipped().cornerRadius(64)
                                        } else {
                                            WebImage(url: URL(string: recentMessage.photoURL)).resizable().scaledToFill().frame(width: 60, height: 60).clipped().cornerRadius(64).overlay(RoundedRectangle(cornerRadius: 64).stroke(Color(.gray), lineWidth: 1)).shadow(radius: 5)
                                        }
                                        
                                        VStack(alignment: .leading, spacing: 20) {
                                        HStack {
                                            if ( recentMessage.senderName == emp.name) {
                                            Text(recentMessage.receiverName).font(.system(size: 16, weight: .bold)).foregroundColor(.black)
                                            } else {
                                                Text(recentMessage.senderName).font(.system(size: 16, weight: .bold)).foregroundColor(.black)
                                            }
                                            Spacer()
                                            Text(recentMessage.timestamp.timeAgoDisplay()).font(.system(size: 10, weight: .semibold)).foregroundColor(.gray)
                                        }
                                            
                                            Text(recentMessage.text).font(.system(size: 14)).foregroundColor(Color(.darkGray))
                                                .multilineTextAlignment(.leading )
    
                                        }
                                    
                                    }
                                    .padding(10)
                                }
                                .background(NavigationLink(
                                    destination: chatView(chatUser: selectedUser, emp: self.emp),
                                    isActive: $shouldNavigateToChatLogView) {
                                        EmptyView()
                                    }).contentShape(Rectangle())
                                .onTapGesture {
                                    if ( recentMessage.fromID == emp.employee_id ) {
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
                    chatView(chatUser: self.selectedUser, emp: self.emp)
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
                        .padding(.bottom)
                        .shadow(radius: 15)
                }.fullScreenCover(isPresented: $shouldShowNewMessageScreen, onDismiss: nil) {
                    createNewMessageView(emp: self.emp, didSelectNewUser: {
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
    
    static let employee = Employee(employee_id: "", address: "", birthdate: "", department: "", email: "", id: "", gender: "", name: "", national_id: "", phone_number:  "", position: "", photoURL: "")
    
    static var previews: some View {
        messagesView(emp: employee)
    }
}
