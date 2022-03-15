//
//  CalendarGrid.swift
//  Checkly
//
//  Created by a w on 07/02/2022.
//

import SwiftUI
import MapKit
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
    // for attendees sheet
    @State private var showingSheet = false
    // for participants attendance (PA) sheet
    @State private var showingPASheet = false
    // for map view
    @State private var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0,longitude: 0.0),span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    // temp
    @Environment(\.dismiss) var dismiss
    
    var todaysDate = Date()
    
    var body: some View {
        
        NavigationView{
            
            ScrollView(.vertical, showsIndicators: false){
                
                VStack(spacing: 5) {
                    
                    // contains filter group, and plus button
                    HeaderView()
                    
                    // Days
                    let days: [String] = ["S", "M", "T", "W", "T", "F", "S"]
                    
                    ZStack {
                        // sheet 1
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 320, height: 490)
                            .foregroundColor(.gray.opacity(0.1))
                            .offset(x: 0, y: 20)
                        // sheet 2
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 340, height: 495)
                            .foregroundColor(.gray.opacity(0.2))
                            .offset(x: 0, y: 7)
                        // sheet 3
                        RoundedRectangle(cornerRadius: 25)
                            .frame(width: 360, height: 485)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0.1, y: 0.1)
                        VStack {
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
                            
                            LazyVGrid(columns: columns, spacing: 12) {
                                
                                ForEach(extractDate()) { value in
                                    
                                    DatesView(value: value)
                                        .background(
                                            Capsule()
                                                // light blue Color(red: 0.824, green: 0.925, blue: 0.976)
                                                .fill(Color("BlueB"))
                                                .padding(.horizontal, 7)
                                                .opacity(isSameDay(date1: value.date , date2: currentDate) ? 1 : 0)
                                        )
                                        .onTapGesture {
                                            currentDate = value.date
                                        }
                                }
                            }
                        }
                        .padding([.leading, .trailing],32)
                        
                    }
                    
                    // Display tasks
                    VStack(spacing: 15){
                        Text("Today's Tasks")
                            .font(.title2.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.vertical,20)
                        
                        if let meeting = meetingViewModel.meetings.first(where: { meeting in
                            return isSameDay(date1: meeting.datetime_start, date2: currentDate)
                        }) {
                            ForEach(self.meetingViewModel.filteredMeetingsArray(date:currentDate)!){ meeting in
                                Button {
                                    meetingViewModel.selectedMeeting = meeting
                                    // Update coordinate region on click
                                    coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(meetingViewModel.selectedMeeting?.latitude ?? "0.0") ?? 0.0,longitude: Double(meetingViewModel.selectedMeeting?.longitude ?? "0.0") ?? 0.0),span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
                                    DispatchQueue.main.schedule(after: .init(.now() + 0.3)) {
                                        withAnimation{
                                            bottomSheetPosition = .middle
                                        }
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
                .preferredColorScheme(.light)
                .onChange(of: currentMonth) { newValue in
                    // update month
                    currentDate = getCurrentMonth()
                }
            }
            
            // MARK: Meeting Details Sheet
            .bottomSheet(bottomSheetPosition: $bottomSheetPosition, options: [BottomSheet.Options.allowContentDrag,.tapToDismiss, .swipeToDismiss, .backgroundBlur(effect: .dark), .animation(.linear), .cornerRadius(12), .dragIndicatorColor(.gray), .background(AnyView(Color.white))], content: {
                    // see view under "Views" folder
                    MeetingDetails(coordinateRegion: $coordinateRegion,showingSheet: $showingSheet, meeting: self.meetingViewModel.filteredMeetingsArray(date: currentDate)?.filter{$0.id == meetingViewModel.selectedMeeting?.id}.first ?? Meeting(id: "1", host: "none", title: "none", datetime_start: Date(), datetime_end: Date(),type: "none", location: "none", attendees: ["11" : "none"], agenda: "none", latitude: "unavailable", longitude: "unavailable"), showingPASheet: $showingPASheet)
            })
            
            // MARK: Attendees List Sheet
            .sheet(isPresented: $showingSheet) {
                // see view under "Views" folder
                MeetingAttendeesListView(meeting: self.meetingViewModel.filteredMeetingsArray(date: currentDate)?.filter{$0.id == meetingViewModel.selectedMeeting?.id}.first ?? Meeting(id: "1", host: "none", title: "none", datetime_start: Date(), datetime_end: Date(),type: "none", location: "none", attendees: ["11" : "none"], agenda: "none", latitude: "unavailable", longitude: "unavailable"))
            }
            
            // MARK: Take Participants Attendance Sheet
            .sheet(isPresented: $showingPASheet, content: {
                // display Participants Attendance view
                ParticipantsAttendance(meeting: meetingViewModel.selectedMeeting ?? Meeting(id: "1", host: "none", title: "none", datetime_start: Date(), datetime_end: Date(),type: "none", location: "none", attendees: ["11" : "none"], agenda: "none", latitude: "unavailable", longitude: "unavailable"))
                
            })
            
//            .navigationBarHidden(true)
            
            // MARK: TO BE REMOVED
            .navigationBarTitle(Text("Calendar")).toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        dismiss()
                    } label: {
                        HStack{
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
      
        }// Navigation View
    }// body
    
    @ViewBuilder
    func DatesView(value: DateValueModel) -> some View{
        
        VStack{
            if value.day != -1 {
                
                if let meeting = meetingViewModel.meetings.first(where: { meeting in
                    
                    return isSameDay(date1: meeting.datetime_start, date2: value.date)
                }){
                    if isSameDay(date1: todaysDate, date2: value.date){
                            Text("\(value.day)")
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(Color("BlueA"))
                                .frame(maxWidth: .infinity)
                                Spacer()
                                Circle()
                                    .fill(Color("BlueA"))
                                    .frame(width: 6, height: 6)
                                    .padding(.bottom, 6)
                    }
                    else {
                        Text("\(value.day)")
                            .font(.system(size: 16, weight: .medium))
                            .frame(maxWidth: .infinity)
                        Spacer()
                        Circle()
                            .fill(Color("BlueA"))
                            .frame(width: 6, height: 6)
                            .padding(.bottom, 6)
                    }
                }
                else {
                     if isSameDay(date1: todaysDate, date2: value.date){
                        Text("\(value.day)")
                            .font(.system(size: 16, weight: .medium))
                            .foregroundColor(Color("BlueA"))
                            .frame(maxWidth: .infinity)
                        Spacer()
                    }
                    else {
                         Text("\(value.day)")
                            .font(.system(size: 16, weight: .medium))
                            .frame(maxWidth: .infinity)
                    Spacer()
                    }
                }
            }
        }
        .padding(.vertical, 4)
        .frame(height: 50, alignment: .top)
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
                    Text(meeting.datetime_start.formatted(date: .omitted, time: .shortened))
                }
            }
            .padding([.top,.bottom, .trailing], 10)
            
        }
        .background(
            Color(meeting.type == "Online" ? "BlueA" : "Purple")
                .opacity(0.06)
        )
        .cornerRadius(5)
        .padding([.leading,.trailing],10)
    }
    
    func HeaderView() -> some View {
        
        HStack(spacing: 25){
            
            Button(action: {
                // Already in Calendar Grid
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
                // Go to Timeline
                withAnimation {
                    viewRouter.currentPage = .CalendarTimeline
                }
                
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
            })
                .padding([.trailing], 6)
                      
        }
        .padding([.leading],19)
        .padding([.trailing ,.bottom],17)
        .padding([.top],15)
        .hLeading()
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
