//
//  TabView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 14/06/2022.
//

import SwiftUI

struct TabNavigationView: View {
    @State private var current = 2
    
    var body: some View {
        TabView(selection: $current) {
            Text("Services")
                .tabItem{
                    Image(systemName: "square.grid.2x2")
                        .environment(\.symbolVariants, .none)
                }
                .tag(0)
            
            Text("Meetings")
                .tabItem{
                    Image(systemName: "calendar")
                        .environment(\.symbolVariants, .none)
                }
                .tag(1)

            HomeView()
                .tabItem{
                    Image(systemName: "house")
                        .environment(\.symbolVariants, .none)
                }
                .tag(2)

            Text("Analytics")
                .tabItem{
                    Image(systemName: "chart.bar")
                        .environment(\.symbolVariants, .none)
                }
                .tag(3)

            UserProfileView()
                .tabItem{
                    Image(systemName: "gearshape")
                        .environment(\.symbolVariants, .none)
                }
                .tag(4)

        }
        .preferredColorScheme(.light)
    }
}


