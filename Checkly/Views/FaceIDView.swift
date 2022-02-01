//
//  FaceIDView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 02/02/2022.
//

import SwiftUI

struct FaceIDView: View {
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [
                Color(UIColor(named: "Blue")!),
                Color(UIColor(named: "DarkBlue")!),
                Color(UIColor(named: "DarkBlue")!)]), startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            VStack (spacing: 30.0){
                Text("Login Via Face ID")
                    .font(.title)
                    .fontWeight(.bold)
                Text("login to Checkly with your face id, for a quick and secure login")
                    .font(.body)
                    .multilineTextAlignment(.center)
                ZStack{
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(Color(UIColor(named: "Loading")!))
                        .frame(width: 180.0, height: 180.0)
                        .opacity(0.5)
                    VStack (spacing: 15.0){
                        Text( Image(systemName: "faceid"))
                            .font(.system(size: 75.0, weight: .thin))
                        
                        Text("Face ID")
                            .font(.body)
                            .foregroundColor(.black)
                    }
                }
                .padding()
                Text("login to Checkly with your face id, for a quick and secure login")
                    .font(.body)
                    .multilineTextAlignment(.center)
                Button{
                    
                } label: {
                    Text("Login")
                        .fontWeight(.bold)
                        .foregroundColor(Color(UIColor(named: "Blue")!))
                }
                .frame(width: 150.0, height: 45.0)
                .background(.white)
                .cornerRadius(15.0)
                
                
            }
            .foregroundColor(.white)
            .padding(25.0)
            
        }
    }
    
}



struct FaceIDView_Previews: PreviewProvider {
    static var previews: some View {
        FaceIDView()
    }
}
