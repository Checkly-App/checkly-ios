//
//  informManager.swift
//  Checkly
//
//  Created by Norua Alsalem on 04/04/2022.
//

import SwiftUI
import Firebase
import SwiftUILib_DocumentPicker
import FirebaseDatabase
import FirebaseAuth

struct informManager: View {
    
    @State private var showingLateAlert = false
    @State private var showingEarlyAlert = false
    @ObservedObject var vm = informManagerViewModel()
    @State var currentDate = Date()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
    
    var body: some View {
        
        let time = vm.getCurrentTime()
        let date = vm.getCurrentDate()
        
        VStack {
            
            //update time every second
            Text("\(currentDate)")
                .onReceive(timer) { input in
                    currentDate = input
                }.opacity(0)
            
            Text(time).fontWeight(.ultraLight).font(.system(size: 40))
            Text(date).fontWeight(.light).foregroundColor(.gray)
            
            HStack{
                Spacer()
                Text("Notify manager I'll be late").font(.system(size: 16, weight: .bold))
                Spacer()
                }.foregroundColor(.white)
                .padding(.vertical)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.345, green: 0.737, blue: 0.925), Color(red: 0.263, green: 0.624, blue: 0.953)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(32)
                .padding(.horizontal)
                .shadow(radius: 15)
                .contentShape(Rectangle())
                .onTapGesture {
                    showingLateAlert = true
                }.alert("Are you sure you want to inform your manager of being late?", isPresented: $showingLateAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Yes") {
                        vm.updateStatus(newStatus: "Late")
                    }
                }
            
            HStack{
                Spacer()
                Text("Notify manager I'll be early").font(.system(size: 16, weight: .bold))
                Spacer()
                }.foregroundColor(.white)
                .padding(.vertical)
                .background(LinearGradient(gradient: Gradient(colors: [Color(red: 0.345, green: 0.737, blue: 0.925), Color(red: 0.263, green: 0.624, blue: 0.953)]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(32)
                .padding(.horizontal)
                .shadow(radius: 15)
                .contentShape(Rectangle())
                .onTapGesture {
                    showingEarlyAlert = true
                }.alert("Are you sure you want to inform your manager of being early?", isPresented: $showingEarlyAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Yes") {
                        vm.updateStatus(newStatus: "Early")
                    }
                }
                
        
            
        }.padding().navigationTitle("Notify Manager").navigationBarTitleDisplayMode(.inline)
        
    }
    
}

class informManagerViewModel: ObservableObject {
    
    let user = Auth.auth().currentUser


    func updateStatus (newStatus: String) {

        Database.database().reference().root.child("Employee").child(self.user!.uid).updateChildValues(["status": newStatus])
    }
    
    func getCurrentTime() -> String {
        
        let formatter = DateFormatter()
        formatter.timeStyle = .medium
        let dateString = formatter.string(from: Date())
        
        return dateString
    }
    
    func getCurrentDate() -> String {
        
        let formatter3 = DateFormatter()
        formatter3.dateFormat = "E, d MMM y"
        let dateString = formatter3.string(from: Date())
        
        return dateString
    }

        
    }

struct informManager_Previews: PreviewProvider {
    static var previews: some View {
        informManager()
    }
}
