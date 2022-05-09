//  HomeView.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 23/07/1443 AH.
//
import SwiftUI

struct HomeView: View {
    
    
    //MARK: - @State variables
    @State var timeDate = "hh:"
    @State var date = "eeee dd mm yyyy"
    @State var showCardSheet = false
    @State var showSideMenu = false
    
    
    //MARK: - Variables
    var emp: Employee
    var com: Company
    var dep: Department
    
    
    var updateTimer: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.timeDate = getTime()
        }
    }
    
    
    var updateDate: Timer {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.date = getDate()
        }
    }
    
    
    var body: some View {
            ZStack {
                LinearGradient(colors: [Color(.sRGB, red: 1, green: 1, blue: 1, opacity: 1),
                                        Color(.sRGB, red: 0.954, green: 0.954, blue: 0.954, opacity: 1)],
                               startPoint: .top,
                               endPoint: .bottom)
                .ignoresSafeArea()
                VStack(alignment: .center, spacing: 100) {
                    Spacer()
                    Spacer()
                    VStack(alignment: .center, spacing: 8){
                        //1- time
                        Text(timeDate)
                            .foregroundColor(.black)
                            .fontWeight(.semibold)
                            .font(.largeTitle)
                            .onAppear {
                                let _ = self.updateTimer
                            }
                        //2- date
                        Text(date)
                            .foregroundColor(.gray)
                            .font(.title2)
                            .fontWeight(.regular)
                            .onAppear {
                                let _ = self.updateDate
                            }
                    }
                    
                    //3- Digital Card
                    VStack(alignment: .center, spacing: 16) {
                        Rectangle()
                            .fill(Color(CGColor(red: 0.753, green: 0.91, blue: 0.98, alpha: 1)))
                            .cornerRadius(24)
                            .frame(width: 350, height: 250, alignment: .leading)
                            .overlay(alignment: .leading, content: {
                                ZStack{
                                    AsyncImage(url: com.image) { image in
                                        image.resizable()
                                        
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    .opacity(0.1)
                                    .scaleEffect()
                                    .frame(width: 350, height: 250, alignment: .leading)
                                    
                                    VStack(alignment: .leading, spacing: 16){
                                        AsyncImage(url: emp.image) { image in
                                            image.resizable()
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 100, height: 120)
                                        .cornerRadius(16)
                                        
                                        VStack(alignment: .leading, spacing: 8){
                                            Text(emp.name)
                                                .bold()
                                                .font(.system(size: 20))
                                            Text(emp.position)
                                                .font(.system(size: 15))
                                            Text(emp.employee_id)
                                                .font(.system(size: 12))
                                        }
                                    }
                                    .padding(24)
                                    .frame(width: 350, height: 250, alignment: .leading)
                                }
                                .frame(width: 350, height: 250, alignment: .leading)
                                
                            })
                            .shadow(color: .black.opacity(0.09), radius: 20, x: 0.5, y: 0.5)
                    }
                    VStack(alignment: .center, spacing: 32) {
                        HStack{
                            Image(systemName: "paperplane.circle.fill")
                            Text("Location:")
                            Text("Inside the company")
                                .foregroundColor(.green)
                            
                        }
                        
                        //14- check-in information
                        HStack(alignment: .center, spacing: 32) {
                            //15- check-in info
                            VStack(alignment: .center, spacing: 8) {
                                Text("09:10")
                                    .bold()
                                    .font(.system(size: 25))
                                Text("Check-in")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                            }
                            //16- check-out info
                            VStack(alignment: .center, spacing: 8) {
                                Text("--:--")
                                    .bold()
                                    .font(.system(size: 25))
                                Text("Check-out")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                            }
                            //17- working-hours info
                            VStack(alignment: .center, spacing: 8) {
                                Text("04:20")
                                    .bold()
                                    .font(.system(size: 25))
                                Text("Working-hours")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 14))
                            }
                        }
                    }
                    Spacer()
                }
            }
    }
    
    //MARK: - Functions
    /// a function that returns the current time as string
    /// - Returns: string indicates the current time in the format HH:mm
    func getTime()->String{
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let stringDate = timeFormatter.string(from: time)
        return stringDate
    }
    
    /// a function that returns the current date as string
    /// - Returns: string indicates the current date in the format EEEE, MMM d
    func getDate()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE, MMM d")
        return dateFormatter.string(from: Date())
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(emp: Employee(address: "", birthdate: "", department: "", email: "", employee_id: "", gender: "", name: "", national_id: "", phone_number: "", position: "", image: nil, token: ""),com: Company(abbreviation: "", age: "", attendance_strategy: "", industry: "", location: "", name: "", policy: "", size: "", id: "", working_hours: "", geo_id: "", email: ""), dep: Department(company_id: "", dep_id: "", manager: "", name: ""))
    }
}
