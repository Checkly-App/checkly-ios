//
//  MenuView.swift
//  Scheak
//
//  Created by  Lama Alshahrani on 01/07/1443 AH.
//

import SwiftUI

struct MenuView: View {
    @State private var showingSheet = false
    var body: some View {
       

        NavigationView {
            VStack(alignment: .leading ){
                VStack{
                    Image("LogoSidemenu")
                        .resizable()
                           .scaledToFit()
                           .frame(width: 90.0, height: 90.0).padding(.leading,5)
                    Text(" ").fontWeight(.medium).foregroundColor(.gray).font(.headline).multilineTextAlignment(.leading).padding(.top,0.9)
                }.padding(.top,90)
                
                NavigationLink(destination: //ContentView()
                               UserProfile()
                ) {
                    HStack{
                        Image(systemName: "house")
                            .foregroundColor(.gray)
                            .imageScale(.large).font(.system(size: 20.0))
                        Text("Home").fontWeight(.medium).foregroundColor(.gray).font(.headline)
                
                        
                    }
                    .padding(.top,1)
                }
                NavigationLink(destination: UserProfile()){
                HStack{
                    Image(systemName: "person.crop.circle")
                        .foregroundColor(.gray)
                        .imageScale(.large).font(.system(size: 20.0))
                    Text("Profile").foregroundColor(.gray).font(.headline)
                }
                    .padding(.top,30)}
                
                HStack{
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.gray)
                        .imageScale(.large).font(.system(size: 20.0))
                    Text("Log out").foregroundColor(.gray).font(.headline)
                }.padding(.top,30).onTapGesture( perform:             {showingSheet.toggle()}
).fullScreenCover(isPresented: $showingSheet) {
                    UserProfile()
                }
                Spacer()
            }
            .padding().frame(maxWidth:.infinity, alignment:.leading).background( LinearGradient(gradient: Gradient(colors: [Color(red: 207/255, green: 242/255, blue: 242/255), Color(red: 210/255, green: 236/255, blue: 249/255)]), startPoint: .top, endPoint: .bottom)).ignoresSafeArea(.all)
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
