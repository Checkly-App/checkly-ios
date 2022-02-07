//
//  CalendarGrid.swift
//  Checkly
//
//  Created by a w on 07/02/2022.
//

import SwiftUI

struct CalendarGrid: View {
    
    @StateObject var meetingViewModel : MeetingViewModel = MeetingViewModel()
    @Binding var currentDate: Date
    // month update on arrow button click
    @State var currentMonth: Int = 0
    // to switch between screens
    @StateObject var viewRouter: CalendarViewRouterHelper
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false){
            VStack(spacing: 5) {
                            HStack(){
                                Button(action: {
                                    print("Already in Calendar Grid")
                                }, label: {
                                    Image(systemName: "calendar.circle.fill")
                                        .resizable()
                                        .foregroundColor(Color("BlueA"))
                                        .frame(width: 35, height: 35)
                                })
                                Button(action: {
                                    print("Go to Timeline")
                                    viewRouter.currentPage = .CalendarTimeline
                                }, label: {
                                    Image(systemName: "list.bullet.circle")
                                        .resizable()
                                        .foregroundColor(Color("BlueA"))
                                        .frame(width: 35, height: 35)
                                })
                            }.padding(15)
                // Days
                let days: [String] = ["S", "M", "T", "W", "T", "F", "S"]
                
                HStack(spacing: 20) {
                    // go to prev month
                    Button {
                        withAnimation{
                            currentMonth -= 1
                        }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title2.bold())
                            .foregroundColor(Color("BlueA"))
                    }
                    Spacer(minLength: 0)
                    // Display Year number and month name
                    VStack(alignment: .center, spacing: 10) {
                        // year
                        Text(getMonthAndYear()[1])
                            .font(.caption)
                            .fontWeight(.semibold)
                        // month
                        Text(getMonthAndYear()[0])
                            .font(.title.bold())
                    }
                    Spacer(minLength: 0)
                   
                    // go to next month
                    Button {
                        withAnimation{
                            currentMonth += 1
                        }
                    } label: {
                        Image(systemName: "chevron.right")
                            .font(.title2.bold())
                            .foregroundColor(Color("BlueA"))
                    }
                }
                .padding()
                // Display day names
                HStack(spacing: 0) {
                    ForEach(days,id: \.self) { day in
                        Text(day)
                            .font(.callout)
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                    }
                }
                // Dates (Numbers)
                let columns = Array(repeating: GridItem(.flexible()), count: 7)
                
                LazyVGrid(columns: columns, spacing: 15) {
                    
                    ForEach(extractDate()) { value in
                        
                        CardView(value: value)
                            .background(
                                Capsule()
                                    // light blue Color(red: 0.824, green: 0.925, blue: 0.976)
                                    .fill(Color("BlueB"))
                                    .padding(.horizontal, 8)
                                    .opacity(isSameDay(date1: value.date , date2: currentDate) ? 1 : 0)
                            )
                            .onTapGesture {
                                currentDate = value.date
                            }
                    }
                }
                // Display tasks
                VStack(spacing: 15){
                    Text("Today's Tasks")
                        .font(.title2.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical,20)
                    
                    if let meeting = meetingViewModel.meetings.first(where: { meeting in
                        return isSameDay(date1: meeting.dateTime, date2: currentDate)
                    }) {
                        ForEach(self.meetingViewModel.filteredMeetingsArray(date:currentDate)!){ meeting in
                                MeetingCardView(meeting: meeting) }
                    } else {
                        Text("No Tasks Found!")
                            .font(.system(size: 16))
                            .fontWeight(.light)
                    }
                }
                .padding()
                // update meeting
                .onChange(of: meetingViewModel.currentDate){ newValue in
                    meetingViewModel.filterTodayMeetings()
                }
            }
            .onChange(of: currentMonth) { newValue in
                // update month
                currentDate = getCurrentMonth()
            }
        }
    }// body
    
    @ViewBuilder
    func CardView(value: DateValueModel) -> some View{
        
        VStack{
            if value.day != -1 {
                
                if let meeting = meetingViewModel.meetings.first(where: { meeting in
                    
                    return isSameDay(date1: meeting.dateTime, date2: value.date)
                }){
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                    Spacer()
                    Circle()
                        .fill(Color("BlueA"))
                        .frame(width: 8, height: 8)
                }
                else{
                    Text("\(value.day)")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                    Spacer()
                }
            }
        }
        .padding(.vertical, 9)
        .frame(height: 60, alignment: .top)
    }
    // meeting card view
    func MeetingCardView(meeting: Meeting) -> some View {
        
        HStack(alignment: .top, spacing: 30) {
            VStack(spacing: 10){
                    Rectangle()
                    .fill(meeting.type == "Online" ? Color("BlueA") : Color("Purple"))
                    .frame(width: 5)
            }
            VStack(){
                HStack(alignment: .top, spacing: 10){
                    VStack(alignment: .leading, spacing: 12){
                        Text(meeting.title)
                            .font(.title3.bold())
                        Text(meeting.type)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                    .hLeading()
                    // to display time in 12-hour format
                    Text(meeting.dateTime.formatted(date: .omitted, time: .shortened))
                }
            }
            .hLeading()
            .padding(10)
        }
        .hLeading()
        .background(
            Color(meeting.type == "Online" ? "BlueA" : "Purple")
                .opacity(0.06)
        )
        .frame(width: 360)
        .cornerRadius(5)
    }
    
    // checking dates
    func isSameDay(date1: Date, date2: Date) -> Bool {
        
        let calendar = NSCalendar.current
        
        return calendar.isDate(date1, inSameDayAs: date2)
    }
    
    // Exctract Year number and month name
    func getMonthAndYear() -> [String]{
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        
        let date = formatter.string(from: currentDate)
        
        return date.components(separatedBy: " ")
    }
    
    func getCurrentMonth() -> Date {
        let calendar = NSCalendar.current
        // getting current month dates
        guard let currentMonth = calendar.date(byAdding: .month, value: self.currentMonth, to: Date()) else {
            return Date()
        }
        return currentMonth
    }
    
    func extractDate() -> [DateValueModel] {
        
        let calendar = NSCalendar.current
        
        // getting current month dates
        let currentMonth = getCurrentMonth()
        
        var days = currentMonth.getAllDates().compactMap { date -> DateValueModel in
            // getting days
            let day = calendar.component(.day, from: date)
            
            return DateValueModel(day: day, date: date)
        }
        
        // Adding offset days to get exact week days
        let firstWeekDay = calendar.component(.weekday, from: days.first?.date ?? Date())
        
        for _ in 0..<firstWeekDay - 1{
            days.insert(DateValueModel(day: -1, date: Date()), at: 0)
        }
        return days
    }
} // Calendar Date Picker struct

struct CalendarGrid_Previews: PreviewProvider {
    // view it on simulator or real device because you won't be able to interact
    @State static var currentDate: Date = Date()
    static var previews: some View {
        CalendarGrid(currentDate: $currentDate, viewRouter: CalendarViewRouterHelper())
    }
}

// Extending date to get current month dates
extension Date {
    func getAllDates() -> [Date] {
        
        let calendar = NSCalendar.current
        // getting first day of the month
        let startDate = calendar.date(from:NSCalendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        
        return range.compactMap { day -> Date in
            
        return calendar.date(byAdding: .day, value: day-1, to: startDate)!
            
        }
    }
}
