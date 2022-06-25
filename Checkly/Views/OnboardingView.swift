//
//  OnboardingView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 13/06/2022.
//

import SwiftUI

struct OnboardingView: View {
    // MARK: -  Variables
    @Binding var showBoarding: Bool
    @State  var currentIndex = 0
    var numberOfPages = 3
    
    var body: some View {
        TabView(selection: $currentIndex.animation()){
            OnboardingTemplate(firstColor: Color("light-blue-50"),
                               secondColor: Color("light-purple-50"),
                               title: "Automatic Attendance",
                               message: "Automatically check in/out without the need for traditional methods. Through Geofencing techiques, Checkly checks you in the moment you enter the company's premise.",
                               showSkip: true,
                               showBoarding: $showBoarding,
                               currentIndex: $currentIndex)
                .tag(0)
                .ignoresSafeArea()
            OnboardingTemplate(firstColor: Color("light-purple-50"),
                               secondColor: Color("light-teal-50"),
                               title: "Meeting Management",
                               message: "Easily schedule, send and recieve meetings invitations, Track participants attendance and send an automated Minutes of Meetings (MoM) report.",
                               showSkip: true,
                               showBoarding: $showBoarding,
                               currentIndex: $currentIndex)
                .tag(1)
                .ignoresSafeArea()
            OnboardingTemplate(firstColor: Color("light-teal-50"),
                               secondColor: Color("light-green-50"),
                               title: "Employee Management",
                               message: "Checkly provides many features to easily manage and track your work performance. From attendance analytics to leaves management. ",
                               showSkip: false,
                               showBoarding: $showBoarding,
                               currentIndex: $currentIndex)
                .tag(2)
                .ignoresSafeArea()
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .overlay(PaginationView(numberOfPages: numberOfPages, currentIndex: currentIndex), alignment: .bottomLeading)
        .edgesIgnoringSafeArea(.all)
    }
}

struct OnboardingTemplate: View{
    // MARK: - Variables
    var firstColor: Color
    var secondColor: Color
    var title: String
    var message: String
    var showSkip: Bool
    
    // MARK: - @Bindings
    @Binding var showBoarding: Bool
    @Binding  var currentIndex: Int
    
    var body: some View {
        ZStack(alignment: .center){
            // MARK: - Background gradient
            RadialGradient(colors: [firstColor, firstColor.opacity(0)],
                           center: UnitPoint(x: -0.25, y: 0), startRadius: -200, endRadius: UIScreen.main.bounds.height*0.75)
            RadialGradient(colors: [secondColor, secondColor.opacity(0)],
                           center: UnitPoint(x: 1.5, y: 0), startRadius: -200, endRadius: UIScreen.main.bounds.height*0.75)
            // MARK: - Content
            VStack(alignment: .trailing){
                HStack(alignment: .top){
                    Spacer()
                    Button(showSkip ? "skip" : "start"){
                        showBoarding.toggle()
                    }
                }
                .padding(.vertical, 32)
                Spacer()
            }
            .padding(24)
            
            VStack(alignment: .leading, spacing: 16){
                Spacer()
                Text(title)
                    .fontWeight(.semibold)
                    .font(.title)
                Text(message)
                    .font(.body)
                HStack {
                    Spacer()
                    ZStack{
                        Circle()
                            .fill(.white)
                            .frame(width: 64, height: 64)
                            .shadow(color: Color("light-blue-50").opacity(0.15), radius: 15, x: 1, y: 4)
                        Circle()
                            .fill( RadialGradient(colors: [Color("light-teal-50"), Color("light-teal-50").opacity(0)], center: UnitPoint(x: 0.8, y: 0.1), startRadius: -5, endRadius: 50))
                            .frame(width: 64, height: 64)
                        Circle()
                            .fill( RadialGradient(colors: [Color("light-purple-50"), Color("light-purple-50").opacity(0)], center: UnitPoint(x: 0.2, y: -0.1), startRadius: -10, endRadius: 50))
                            .frame(width: 64, height: 64)
                        Circle()
                            .fill( RadialGradient(colors: [Color("light-blue-50"), Color("light-blue-50").opacity(0)], center: UnitPoint(x: 0.5, y: -0.2), startRadius: -10, endRadius: 50))
                            .frame(width: 64, height: 64)
                        
                        Image(systemName: "arrow.forward")
                            .font(.system(size: 24, weight: .semibold))
                    }
                    .onTapGesture{
                        if showSkip {
                            withAnimation { currentIndex = currentIndex+1 }
                        } else {
                            showBoarding.toggle()
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 0, leading: 32, bottom: UIScreen.main.bounds.height*0.25, trailing: 32))
        }
        .foregroundColor(Color("coal"))
        .preferredColorScheme(.light)
    }
}


