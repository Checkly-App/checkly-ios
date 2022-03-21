//
//  tabview3.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 21/03/2022.
//

import SwiftUI

struct TabView: View {
    
    //MARK: - @States
    @State var selectedTab = 2
    
    //MARK: - @NameSpaces
    @Namespace var animation
    
    //MARK: - @SatateObjects
    @ObservedObject var tabModelObject = tabViewModel()
    
    //MARK: - Variables
    var tabsNames = ["Messages","Calendar","Home","Statistics","Services"]
    var tabsImages = ["envelope","calendar","house","chart.bar","square.grid.2x2"]
    var selectedTabsImages = ["envelope.fill","calendar","house.fill","chart.bar.fill","square.grid.2x2.fill"]
    
    
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                ZStack {
                    //1- Messages View
                    if selectedTab == 0 {
                        NavigationView {
                            VStack(spacing: 0) {
                                messagesView(emp: tabModelObject.emp)
                                    .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .center)
                                tabBarView
                            }
                        }
                    }
                    
                    //2- Calendar View
                    else if selectedTab == 1 {
                        NavigationView {
                            VStack(spacing: 0) {
                                Text("Calendar")
                                    .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .center)
                                tabBarView
                            }
                        }
                    }
                    
                    //3- Home View
                    else if selectedTab == 2 {
                        NavigationView {
                            VStack(spacing: 0) {
                                HomeView(emp: tabModelObject.emp)
                                tabBarView
                            }
                        }
                    }
                    
                    //4- Statistics View
                    else if selectedTab == 3 {
                        NavigationView {
                            VStack(spacing: 0) {
                                Text("Statistics")
                                    .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .center)
                                tabBarView
                            }
                        }
                    }
                    
                    //5- Services View
                    else if selectedTab == 4 {
                        NavigationView {
                            VStack(spacing: 0) {
                                Text("Services")
                                    .frame(maxWidth: .infinity,maxHeight: .infinity, alignment: .center)
                                tabBarView
                            }
                        }
                    }
                }
            }
//            if !tabModelObject.isHomeLoaded{
//                ZStack{
//                    Color.white
//                        .ignoresSafeArea()
//                        .opacity(0.9)
//                    ProgressView()
//                        .progressViewStyle(CircularProgressViewStyle(tint: Color(.sRGB, red: 0.024, green: 0.661, blue: 0.958, opacity: 1)))
//                        .scaleEffect(3)
//                }
//            }
        }
    }
    
    var tabBarView: some View {
        VStack(spacing: 0) {
            Divider()
            HStack(spacing: 0){
                ForEach((0..<5) , id: \.self){ tab in
                    Button {
                        withAnimation {
                            selectedTab = tab
                        }
                    } label: {
                        VStack(spacing: 0){
                            ZStack{
                                //9- indicator view
                                Indicator()
                                    .fill(Color.clear)
                                    .frame(width: 45, height: 6)
                                
                                if selectedTab == tab {
                                    Indicator()
                                        .fill(Color(red: 0.333, green: 0.667, blue: 0.984))
                                        .frame(width: 45, height: 6)
                                        .matchedGeometryEffect(id: "tabChange", in: animation)
                                }
                            }
                            .padding(.bottom,10)
                            VStack(spacing: 8){
                                //10- tab view item image
                                Image(systemName: selectedTab == tab ? selectedTabsImages[tab] : tabsImages[tab] )
                                    .renderingMode(.template)
                                    .resizable()
                                    .foregroundColor(selectedTab == tab ? Color(red: 0.333, green: 0.667, blue: 0.984) : Color.gray)
                                    .frame(width: tab == 0 ? 28 :24, height: tab == 0 ? 22 :24)
                                //11- tab view item text
                                Text(tabsNames[tab])
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(selectedTab == tab ? Color(red: 0.333, green: 0.667, blue: 0.984) : Color.gray)
                                    .opacity(selectedTab == tab ? 1 : 0)
                            }
                        }
                    }
                    //12- if the selected tab view item is the last
                    if tab != 4 {
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding([.leading,.trailing],20)
            .background(Color.white)
            .ignoresSafeArea()
        }
        .frame(height: 42)
        .background(Color.white.edgesIgnoringSafeArea(.all))
    }
}

struct Indicator: Shape{
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        return Path(path.cgPath)
    }
}

struct TabView_Previews: PreviewProvider {
    static var previews: some View {
        TabView()
    }
}
