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
    
    @State private var showingAlert = false
    @ObservedObject var vm = informManagerViewModel()
    
    var body: some View {
    
        VStack {
            
            Spacer()
            
            
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
                    showingAlert = true
                }.alert("Are you sure you want to inform your manager of being late?", isPresented: $showingAlert) {
                    Button("Cancel", role: .cancel) { }
                    Button("Yes") {
                        vm.updateStatus(newStatus: "Late")
                    }
                }
                
        
            
        }.padding().navigationTitle("").navigationBarTitleDisplayMode(.inline)
        
    }
    
}

class informManagerViewModel: ObservableObject {
    
    let user = Auth.auth().currentUser


    func updateStatus (newStatus: String) {

        Database.database().reference().root.child("Employee").child(self.user!.uid).updateChildValues(["status": newStatus])
    }
        
    }

struct informManager_Previews: PreviewProvider {
    static var previews: some View {
        informManager()
    }
}
