//
//  UserProfile.swift
//  Scheak
//
//  Created by  Lama Alshahrani on 01/07/1443 AH.
//

import SwiftUI
import Firebase

struct UserProfile: View {

    var body: some View {
        VStack{
            Image(systemName: "person.circle.fill")
                                                                                                                                                                                                        .foregroundColor(.white)
                                                                                                                                                                                                        .imageScale(.large).font(.system(size: 100.0)).padding(.top,10)
            Text("Shahad Alshahrani").fontWeight(.semibold).foregroundColor(Color(hue: 1.0, saturation: 0.015, brightness: 0.345)).padding(.top,0)
            Text("Software Engnering | Oprations").fontWeight(.regular).foregroundColor(.gray).padding(.top,0.2)
            ZStack{
                VStack(alignment: .leading,spacing: 10){
                    VStack(alignment: .leading){ Text("Email:").frame( alignment: .leading).foregroundColor(.gray)
                        Text("Shahad.sjsgmail.com")
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,50)
                    
                 
                   
                    VStack(alignment: .leading){ Text("Gender:").frame( alignment: .leading).foregroundColor(.gray)
                        Text("Female")
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,10)
                    VStack(alignment: .leading){ Text("Address:").frame( alignment: .leading).foregroundColor(.gray)
                        Text("Riyadh")
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,10)
                    VStack(alignment: .leading){ Text("Birth Date:").frame( alignment: .leading).foregroundColor(.gray)
                        Text("22/10/2022")
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,10)
                    VStack(alignment: .leading){ Text("Employee ID:").frame( alignment: .leading).foregroundColor(.gray)
                        Text("22102022")
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,10)
                    VStack(alignment: .leading){ Text("National ID:").frame( alignment: .leading).foregroundColor(.gray)
                        Text("22102022")
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,10)
                    VStack(alignment: .leading){ Text("Phone Number:").frame( alignment: .leading).foregroundColor(.gray)
                        Text("0566041405")
                            .foregroundColor(Color.black)
                        
                    }.padding(.top,10)
Spacer()
                }.frame( alignment: .leading).padding(.leading,-150)
                
                
                
            }.frame( maxWidth: .infinity,  maxHeight: .infinity).background(.white).cornerRadius(30).padding(.top,35).shadow(radius: 4.0)
       Spacer() }.frame( maxWidth: .infinity,  maxHeight: .infinity).background( LinearGradient(gradient: Gradient(colors: [Color(red: 207/255, green: 242/255, blue: 242/255), Color(red: 210/255, green: 236/255, blue: 249/255)]), startPoint: .top, endPoint: .bottom))
                                                                         
        
            }
    func read(){
       // let db = Firestore.firestore()
let ref = Database.database().reference()

    }
    
    
}


struct UserProfile_Previews: PreviewProvider {
    static var previews: some View {
        UserProfile()
    }
}
