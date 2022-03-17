//
//  HomeView.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 23/07/1443 AH.
//

import SwiftUI

struct HomeView: View {
    
    @State var timeDate = "hh:"
    @State var date = "eeee dd mm yyyy"
    @State var showCardSheet = false
    
    var emp: Employee
    
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
        NavigationView{
            
            ZStack {
                LinearGradient(colors: [Color(.sRGB, red: 1, green: 1, blue: 1, opacity: 1),
                                        Color(.sRGB, red: 0.954, green: 0.954, blue: 0.954, opacity: 1)],
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()
                VStack(alignment: .center, spacing: 24) {
                                    
                    //time
                    Text(timeDate)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .font(.largeTitle)
                        .onAppear {
                            let _ = self.updateTimer
                        }
                    
                    
                    //date
                    Text(date)
                        .foregroundColor(.gray)
                        .font(.title2)
                        .fontWeight(.regular)
                        .onAppear {
                            let _ = self.updateDate
                        }
                    //Digital Card
                    RoundedRectangle(cornerRadius: 16)
                        .frame(width: 320, height: 420)
                        .foregroundColor(Color(.sRGB, red: 0.958, green: 0.987, blue: 1, opacity: 1))
                        .shadow(color: Color(.sRGB, red: 0, green: 0, blue: 0, opacity: 0.2), radius: 10, x: 0.2, y: 0.2)
                        .overlay(
                            VStack(spacing: 0){
                                RoundedRectangle(cornerRadius: 8)
                                    .frame(width: 100, height: 10, alignment: .center)
                                    .foregroundColor(.white)
                                    .shadow(color: .gray, radius: 2, x: -1, y: -1)
                                    .offset(x: 0, y: 15)
                                Spacer()
                                Rectangle()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 120)
                                    .foregroundColor(Color(.sRGB, red: 0.745, green: 0.91, blue: 0.98, opacity: 1))
                            }
                                .cornerRadius(16)
                        )
                        .onTapGesture {
                            self.showCardSheet.toggle()
                        }
                        .sheet(isPresented: $showCardSheet) {
                            CardExpansion(emp: emp)
                        }
                    
                    if showCardSheet {
                        // sheet
                    }
                    
                    //location
                    Text(emp.name)
                    
                    //check-in information
                    
                }
                .navigationTitle("Home")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            
                        } label: {
                            Image(systemName: "line.horizontal.3")
                                .resizable()
                                .frame(width: 24, height: 20)
                                .foregroundColor(Color(.sRGB, red: 0.024, green: 0.661, blue: 0.958, opacity: 1))
                            
                        }
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            
                        } label: {
                            Image(systemName: "bell")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Color(.sRGB, red: 0.024, green: 0.661, blue: 0.958, opacity: 1))
                        }
                    }
            }
            }
        }
    }
    
    //MARK: - Functions
    func getTime()->String{
        let time = Date()
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let stringDate = timeFormatter.string(from: time)
        return stringDate
    }
    
    func getDate()-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEE MMM d yyyy")
        return dateFormatter.string(from: Date())
    }
    
    
}


struct DigitalCard: Shape{
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        
        path.move(to: CGPoint(x: rect.minX, y: rect.height/3))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.height/3))
        
        
        
        return path
    }
}

struct HomeView_Previews: PreviewProvider {
    
    static let employee = Employee(employee_id: "", address: "", birthdate: "", department: "", email: "", id: "", gender: "", name: "", national_id: "", phone_number:  "", position: "", photoURL: "")
    
    static var previews: some View {
        HomeView(emp: employee)
    }
}
