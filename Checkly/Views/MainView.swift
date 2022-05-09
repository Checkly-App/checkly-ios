//
//  MainView.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 23/07/1443 AH.
//

import SwiftUI
import FirebaseAuth

struct MainView: View {
    
    //MARK: - @ObservedObjects
    @ObservedObject var model = MainViewModel()
    
    //MARK: - @State variables
    @State var selection = 3
    
    //MARK: - init function
    init(){
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = .white
    }
    
    //MARK: - Body
    var body: some View {
        //1- container view
        NavigationView{
            //2- tab view
            TabView(selection: $selection) {
                
                //3- calendar tab view
                //TODO: Replace Text("Calendar") with the name of your view
                Text("Calendar")
                    .tabItem {
                        Image(systemName: "calendar")
                        Text("Calendar")
                    }
                    .tag(1)
                
                //4- calendar tab view
                //TODO: Replace Text("Statistics") with the name of your view
                Text("Statistics")
                    .tabItem {
                        Image(systemName: "chart.bar.fill")
                        Text("Statistics")
                    }
                    .tag(2)
                
                //5- home tab view
                GeometryReader { geometry in
                    HomeView(emp: model.emp, com: model.com, dep: model.dep)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .ignoresSafeArea()
                }
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
                .tag(3)
                
                //6- services tab view
                //TODO: Replace Text("Services") with the name of your view
                Text("Services")
                    .tabItem {
                        Image(systemName: "rectangle.3.offgrid.fill")
                        Text("Services")
                    }
                    .tag(4)
                
                //7- settings tab view
                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
                    .tag(5)
                
                
            }
            .onChange(of: selection, perform: { newValue in
                selection = newValue
            })
            .font(.headline)
        }
    }
}


struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
