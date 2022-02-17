//
//  CalendarGrid.swift
//  Checkly
//
//  Created by a w on 07/02/2022.
//

import SwiftUI
import BottomSheet

struct CalendarGrid: View {
    
    @ObservedObject var meetingViewModel : MeetingViewModel = MeetingViewModel()
    @Binding var currentDate: Date
    // month update on arrow button click
    @State private var currentMonth: Int = 0
    // to switch between screens
    @StateObject var viewRouter: CalendarViewRouterHelper
    // for half modal sheet
    @State private var bottomSheetPosition: BottomSheetPosition = .hidden
    
    var todaysDate = Date()
    
    var body: some View {
        NavigationView{
                ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 5) {
                    HStack(spacing: 25){
                                    Button(action: {
                                        print("Already in Calendar Grid")
                                    }, label: {
                                        Image(systemName: "calendar")
                                            .resizable()
                                            .foregroundColor(Color(.gray))
                                            .frame(width: 20, height: 20)
                                            .overlay(
                                                RoundedRectangle(cornerRadius: 25)
                                                    .fill(Color("BlueA").opacity(0.3))
                                                    .frame(width: 40, height: 35)
                                            )
                                    })
                                    Button(action: {
                                        print("Go to Timeline")
                                        viewRouter.currentPage = .CalendarTimeline
                                    }, label: {
                                        Image(systemName: "list.bullet")
                                            .resizable()
                                            .foregroundColor(Color(.gray))
                                            .frame(width: 18, height: 18)
                                    })
                                    Spacer()
                                    Button(action: {
                                        // Generate Meeting
                                    }, label: {
                                        Image(systemName: "plus")
                                            .resizable()
                                            .foregroundColor(Color(.gray))
                                            .frame(width: 20, height: 20)
                                    }).padding([.trailing], 6)
                                  
                    }.padding([.leading],19)
                    .padding([.trailing ,.bottom],10)
                    .padding([.top],15)
                        .hLeading()
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
                                Button {
                                    meetingViewModel.selectedMeeting = meeting
                                    withAnimation{
                                        bottomSheetPosition = .middle
                                    }
                                } label: {
                                    MeetingCardView(meeting: meeting)
                                }.foregroundColor(.black)
                            }
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
                // Meeting Details
                .bottomSheet(bottomSheetPosition: $bottomSheetPosition, options: [BottomSheet.Options.allowContentDrag,.tapToDismiss, .swipeToDismiss, .backgroundBlur(effect: .dark), .animation(.linear), .cornerRadius(12), .dragIndicatorColor(.gray)], content: {
                    VStack(spacing: 20) {
                        HStack(alignment: .top) {
                            // meeting title
                            Text(meetingViewModel.selectedMeeting?.title ?? "")
                                .font(.system(size: 25, weight: .bold))
                                .fontWeight(.semibold)
                                .hLeading()
                            // meeting type
                            ZStack{
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(meetingViewModel.selectedMeeting?.type ?? "" == "Online" ? Color("BlueA").opacity(0.2) : Color("Purple").opacity(0.2))
                                            .frame(width: 75, height: 38)
                                Text(meetingViewModel.selectedMeeting?.type ?? "")
                                    .font(.system(size: 17, weight: .semibold))
                                    .foregroundColor(meetingViewModel.selectedMeeting?.type ?? "" == "Online" ? Color("BlueA"): Color("Purple"))
                                    }
                                    .padding(.trailing, 10)
                                }
                                .padding([.leading], 15)
                        // Host name
                        Text("By: \(meetingViewModel.getHostName(hostID: meetingViewModel.selectedMeeting?.host ?? "None"))")
                             .font(.system(size: 16, weight: .semibold))
                             .foregroundColor(.gray)
                             .hLeading()
                             .padding([.leading], 15)
                        // MARK: Attendees images
                        Divider()
                        // meeting time
                        HStack(spacing: 13) {
                            Image( systemName: "clock")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text(meetingViewModel.selectedMeeting?.dateTime.formatted(date: .omitted, time: .shortened) ?? "")
                                .font(.system(size: 19, weight: .semibold))
                                
                        }
                        .foregroundColor(.gray)
                        .hLeading()
                        .padding([.leading], 15)
                        .padding([.top], 5)
                        
                        // meeting date
                        HStack(spacing: 13) {
                            Image( systemName: "calendar")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text(meetingViewModel.selectedMeeting?.dateTime.formatted(date: .abbreviated, time: .omitted) ?? "")
                                .font(.system(size: 19, weight: .semibold))
                                
                            }
                            .foregroundColor(.gray)
                            .hLeading()
                            .padding([.leading], 15)
                            .padding([.top], 5)
                        
                        // meeting location
                        HStack(spacing: 13) {
                            Image( systemName: "mappin.and.ellipse")
                                .resizable()
                                .foregroundColor(Color(.gray))
                                .frame(width: 19, height: 21)
                            if meetingViewModel.selectedMeeting?.type ?? "" == "Online" {
                                Link("\(meetingViewModel.selectedMeeting?.location ?? "")",destination: URL(string: "\(meetingViewModel.selectedMeeting?.location ?? "")")!)
                                            .font(.system(size: 19, weight: .semibold))
                            } else {
                                Text(meetingViewModel.selectedMeeting?.location ?? "")
                                    .font(.system(size: 19, weight: .semibold))
                                    .foregroundColor(.gray)
                                    }
                                }
                                .hLeading()
                                .padding([.leading], 15)
                                .padding([.top], 5)
                        
                        // Fix multiline image issue
                        // meeting agenda
                        HStack(spacing: 13) {
                            Image( systemName: "text.alignleft")
                                .resizable()
                                .frame(width: 19, height: 19)
                            Text(meetingViewModel.selectedMeeting?.agenda ?? "")
                                .font(.system(size: 19, weight: .semibold))
                                .multilineTextAlignment(.leading)
                            }
                            .foregroundColor(.gray)
                            .hLeading()
                            .padding([.leading], 15)
                            .padding([.top], 5)

                    }
                })
            .navigationBarHidden(true)
        .navigationBarTitle(Text("Calendar"))
      }
    }// body
    
    @ViewBuilder
    func CardView(value: DateValueModel) -> some View{
        
        VStack{
            if value.day != -1 {
                
                if let meeting = meetingViewModel.meetings.first(where: { meeting in
                    
                    return isSameDay(date1: meeting.dateTime, date2: value.date)
                }){
                    if isSameDay(date1: todaysDate, date2: value.date){
                            Text("\(value.day)")
                                .font(.title3.bold())
                                .foregroundColor(Color("BlueA"))
                                .frame(maxWidth: .infinity)
                                Spacer()
                                Circle()
                                    .fill(Color("BlueA"))
                                    .frame(width: 8, height: 8)
                    }
                    else {
                        Text("\(value.day)")
                            .font(.title3.bold())
                            .frame(maxWidth: .infinity)
                        Spacer()
                        Circle()
                            .fill(Color("BlueA"))
                            .frame(width: 8, height: 8)
                    }
                }
                else {
                     if isSameDay(date1: todaysDate, date2: value.date){
                        Text("\(value.day)")
                            .font(.title3.bold())
                            .foregroundColor(Color("BlueA"))
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                    else {
                         Text("\(value.day)")
                        .font(.title3.bold())
                        .frame(maxWidth: .infinity)
                    Spacer()
                    }
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
                            .multilineTextAlignment(.leading)
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
            .padding([.top,.bottom, .trailing], 10)
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
//    @State static var currentDate: Date = Date()
    
    static var previews: some View {
        Calendar(viewRouter: CalendarViewRouterHelper())
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
