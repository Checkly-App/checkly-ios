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
        
        VStack (spacing: 80) {
            
            //update time every second
            Text("\(currentDate)")
                .onReceive(timer) { input in
                    currentDate = input
                }.opacity(0)
            
            VStack ( spacing: 0){
            Text(time).fontWeight(.ultraLight).font(.system(size: 40))
            Text(date).fontWeight(.light).foregroundColor(.gray)
            }
            
            VStack (spacing: 20) {
                ZStack {

                    Ellipse()
                        .fill(Color(red: 0.145, green: 0.816, blue: 0.816))
                    .frame(width: 130, height: 130)
                    
                    Ellipse()
                        .fill(Color(red: 0.145, green: 0.816, blue: 0.816).opacity(0.5))
                    .frame(width: 165, height: 165)
                    
                    Ellipse()
                        .fill(Color(red: 0.145, green: 0.816, blue: 0.816).opacity(0.3))
                    .frame(width: 195, height: 195)
                    Text("I'll be late").foregroundColor(.white)
                }.contentShape(Ellipse())
                        .onTapGesture {
                            showingLateAlert = true
                        }.alert("Are you sure you want to inform your manager of being late?", isPresented: $showingLateAlert) {
                            Button("Cancel", role: .cancel) { }
                            Button("Yes") {
                                vm.updateStatus(newStatus: "Late")
                            }
                        }
                
                ZStack {

                    Ellipse()
                        .fill(Color(red: 0.173, green: 0.686, blue: 0.933))
                    .frame(width: 130, height: 130)
                    
                    Ellipse()
                        .fill(Color(red: 0.173, green: 0.686, blue: 0.933).opacity(0.5))
                    .frame(width: 165, height: 165)
                    
                    Ellipse()
                        .fill(Color(red: 0.173, green: 0.686, blue: 0.933).opacity(0.3))
                    .frame(width: 195, height: 195)
                    Text("I'll be early").foregroundColor(.white)
                }.contentShape(Ellipse())
                    .onTapGesture {
                        showingEarlyAlert = true
                    }.alert("Are you sure you want to inform your manager of being early?", isPresented: $showingEarlyAlert) {
                        Button("Cancel", role: .cancel) { }
                        Button("Yes") {
                            vm.updateStatus(newStatus: "Early")
                        }
                    }
            }
                
        Spacer()
            
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
