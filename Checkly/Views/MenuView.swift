//
//  MenuView.swift
//  Scheak
//
//  Created by  Lama Alshahrani on 01/07/1443 AH.
//

import SwiftUI

struct MenuView: View {
    @State private var showingSheet = false
    @State private var showingSheetpass = false

    var body: some View {
       

       
            VStack(alignment: .leading ){
                HStack{
                    Image("LogoSidemenu")
                        .resizable()
                           .scaledToFit()
                           .frame(width: 40.0, height: 40.0).padding(.leading,0)
                    Text("Checkly ").fontWeight(.light).foregroundColor(.gray).font(.title).multilineTextAlignment(.leading).padding(.top,0.9)
                }.padding(.top,90).padding(.bottom,20)
                
                
                   
                
                HStack{
                    Image(systemName: "person.crop.circle")
                        .foregroundColor(.gray)
                        .imageScale(.large).font(.system(size: 20.0))
                    Text("Profile").foregroundColor(.gray).font(.headline)
                }.padding(.top,20).onTapGesture( perform:             {showingSheet.toggle()}
).fullScreenCover(isPresented: $showingSheet) {
                    UserProfile()
                }
                HStack{
                    Image(systemName: "lock.square")
                        .foregroundColor(.gray)
                        .imageScale(.large).font(.system(size: 20.0))
                    Text("Change password").foregroundColor(.gray).font(.headline)
                }.padding(.top,5).onTapGesture( perform:             {showingSheetpass.toggle()}
).fullScreenCover(isPresented: $showingSheetpass) {
                    ChangePasswordView()
                }
                VStack(alignment:.leading){
                    Divider()
                HStack{
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                        .foregroundColor(.gray)
                        .imageScale(.large).font(.system(size: 20.0))
                    Text("Log out").foregroundColor(.gray).font(.headline)
                }.padding(.top,5).onTapGesture( perform:             {showingSheet.toggle()}
).fullScreenCover(isPresented: $showingSheet) {
                    UserProfile()
                }
                }.padding(.top,550)
            
                Spacer()
            }
            .padding().frame(maxWidth:.infinity, alignment:.leading).background( LinearGradient(gradient: Gradient(colors: [Color(red: 207/255, green: 242/255, blue: 242/255), Color(red: 210/255, green: 236/255, blue: 249/255)]), startPoint: .top, endPoint: .bottom)).ignoresSafeArea(.all)
        
        }
    
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
