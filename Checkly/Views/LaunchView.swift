//
//  launchView.swift
//  Shared
//
//  Created by Noura Alsulayfih on 02/07/1443 AH.
//
import SwiftUI

struct LaunchView: View {
    
    //MARK: - @States
    @State var showHome = false
    @AppStorage("isSignedOut") var isSignedOut = false
    
    
    var body: some View {
        
        VStack{
            if isSignedOut {
                LoginView()
            }
            else {
                if showHome == true {
                    LoginView()
                }else{
                    Image("Checkly-logo")
                        .resizable()
                        .frame(width: 300, height: 230, alignment: .center)
                }
            }
        }
        .preferredColorScheme(.light)
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                        showHome.toggle()
                    
                }
            }
        }
    }
}

struct launchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
