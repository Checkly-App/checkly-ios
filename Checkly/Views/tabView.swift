//  HomeView.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 23/07/1443 AH.
//


import SwiftUI
import FirebaseAuth

struct tabView: View {
    
    //MARK: - @EnvironmentObjects
    @EnvironmentObject var authentication: Authentication
    
    //MARK: - @States
    @State var selectedTab = 2
    
    //MARK: - @NameSpaces
    @Namespace var animation
    
    //MARK: - Variables
    var tabsNames = ["Messages","Calendar","Home","Statistics","Services"]
    var tabsImages = ["envelope","calendar","house","chart.bar","square.grid.2x2"]
    
    var body: some View {
        VStack(spacing: 0) {
            
            GeometryReader{_ in
                ZStack{
                        //Messages
                        Text("Messages")
                            .opacity(selectedTab == 0 ? 1 : 0)
                        
                        //Calendar
                        Text("Calendar")
                            .opacity(selectedTab == 1 ? 1 : 0)
                        //Home
                        HomeView()
                            .opacity(selectedTab == 2 ? 1 : 0)
                        //Statistics
                        Text("Statistics")
                            .opacity(selectedTab == 3 ? 1 : 0)
                        //Services
                        Text("Services")
                            .opacity(selectedTab == 4 ? 1 : 0)
                }
            }
            
            HStack(spacing: 0){
                ForEach((0..<5) , id: \.self){ tab in
                    Button {
                        withAnimation {
                            selectedTab = tab
                        }
                    } label: {
                        VStack(spacing: 0){
                            ZStack{
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
                            VStack{
                                Image(systemName: tabsImages[tab] )
                                    .renderingMode(.template)
                                    .resizable()
                                    .foregroundColor(selectedTab == tab ? Color(red: 0.333, green: 0.667, blue: 0.984) : Color.gray)
                                    .frame(width: 28, height: 24)
                                
                                Text(tabsNames[tab])
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(selectedTab == tab ? Color(red: 0.333, green: 0.667, blue: 0.984) : Color.gray)
                                    .opacity(selectedTab == tab ? 1 : 0)
                            }
                        }
                    }
                    if tab != 4 {
                        Spacer(minLength: 0)
                    }
                }
            }
            .padding([.bottom,.leading,.trailing],20)
            .background(Color.white)
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
        .background(Color.black.opacity(0.06).ignoresSafeArea())
    }
}


struct Indicator: Shape{
    
    func path(in rect: CGRect) -> Path {
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: [.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 10, height: 10))
        
        return Path(path.cgPath)
    }
}

struct tabView_Previews: PreviewProvider {
    static var previews: some View {
        tabView()
    }
}
