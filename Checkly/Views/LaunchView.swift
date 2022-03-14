//
//  launchView.swift
//  Shared
//
//  Created by Noura Alsulayfih on 02/07/1443 AH.
//
import SwiftUI

struct LaunchView: View {
    
    //MARK: - @States
    @State var showOnBoarding = false
    @State var showHome = false
    @AppStorage("isSignedOut") var isSignedOut = false
    
    
    var body: some View {
        
        VStack{
            if isSignedOut {
                LoginView()
            }
            else {
                if showOnBoarding == true {
                    FirstOnboardingView()
                }else if showHome == true {
                    LoginView()
                }else{
                    Image("launch-logo")
                        .resizable()
                        .frame(width: 300, height: 230, alignment: .center)
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    if UserDefaults.standard.bool(forKey: "KeyOnBoardingViewShown") == false {
                        showOnBoarding.toggle()
                        UserDefaults.standard.setValue(true, forKey: "KeyOnBoardingViewShown")
                    }else{
                        showHome.toggle()
                    }
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
