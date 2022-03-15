//
//  CardExpansion.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 27/07/1443 AH.
//

import SwiftUI
import Firebase

struct CardExpansionDetails: View {
    var body: some View {
        
        //Container for the whole view
        VStack{
            
            // 1-Container for the date, location and attendance status
            VStack(alignment: .center, spacing: 16){
                Text("February 13 2022")
                    .fontWeight(.bold)
                    .font(.system(size: 35))
                Text("SDAIA Central Building")
                    .font(.body)
                    .foregroundColor(Color(.sRGB, red: 0.463, green: 0.463, blue: 0.463, opacity: 1))
                Text("On-time")
                    .frame(width: 100, height: 40)
                    .background(Color(.sRGB, red: 0.239, green: 0.824, blue: 0.733, opacity: 0.5))
                    .cornerRadius(8)
            }
            
            // 2-Container for the check-in, check-out and working hours information
            Form{
                Section{
                    HStack{
                        Text("Check-in")
                            .fontWeight(.medium)
                        Spacer()
                        Text("09:03:09 AM")

                    }
                    .padding(10)

                    
                    HStack{
                        Text("Check-out")
                            .fontWeight(.medium)
                        Spacer()
                        Text("06:09:35 PM")
                    }
                    .padding(10)
                    
                    HStack{
                        Text("Working hours")
                            .fontWeight(.medium)
                        Spacer()
                        Text("9 hours, 6 minutes")
                    }
                    .padding(10)

                }
                
                Section{
                    Button {
                        //send request of an issue
                    } label: {
                        Text("Report an issue")
                            .fontWeight(.medium)
                            .foregroundColor(Color(.sRGB, red: 0.024, green: 0.661, blue: 0.958, opacity: 1))
                    }

                }
            }
            .onAppear(perform: {
                UITableView.appearance().backgroundColor = .clear
                UITableView.appearance().sectionHeaderHeight = .zero
                UITableView.appearance()
            })
            .padding()
            
            Text("Generated and projected by Checkly")
                .foregroundColor(.gray)
                .font(.system(size: 15))
                .padding([.bottom],24)
            
        }
        .ignoresSafeArea()
        .padding([.top],50)
        .background(
            LinearGradient(colors: [Color(.sRGB, red: 1, green: 1, blue: 1, opacity: 1),Color(.sRGB, red: 0.954, green: 0.954, blue: 0.954, opacity: 1)], startPoint: .top, endPoint: .bottom)
        )
    }
}

struct CardExpansionDetails_Previews: PreviewProvider {
    static var previews: some View {
        CardExpansionDetails()
    }
}
