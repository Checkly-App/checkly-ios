//
//  CalendarTimeline.swift
//  Checkly
//
//  Created by a w on 07/02/2022.
//

import SwiftUI
import MapKit

import BottomSheet

struct CalendarTimeline: View {
    
     @ObservedObject var meetingViewModel: MeetingViewModel = MeetingViewModel()
     @Namespace var animation
     // to switch between screens
     @StateObject var viewRouter: CalendarViewRouterHelper
     // for bottom sheet
     @State private var bottomSheetPosition: BottomSheetPosition = .hidden
     // for attendees sheet
     @State private var showingSheet = false
     // for participants attendance (PA) sheet
     @State private var showingPASheet = false
     // for map view
     @State private var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0,longitude: 0.0),span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    
     var body: some View {
             
             VStack(spacing: -20){

                 VStack {
                     HeaderView()
                         // MARK: Current Week View
                         // horizontal scroll view to select dates
                     ScrollView(.horizontal, showsIndicators: false){
                             
                             HStack(spacing: 10){
                                 
                                 ForEach(meetingViewModel.currentWeek, id: \.self){ day in
                                     
                                     VStack(spacing: 10) {
                                         
                                         // dd will return date as 01,02,30, ..
                                         Text(meetingViewModel.extractDate(date: day, format: "dd"))
                                             .font(.system(size: 14))
                                             .fontWeight(.semibold)
                                         
                                         // EEE wil return day as SUN,MON, ..
                                         Text(meetingViewModel.extractDate(date: day, format: "EEE"))
                                             .font(.system(size: 14))
                                             .fontWeight(.semibold)
                                         
                                         Circle()
                                             .fill(Color("BlueA"))
                                             .frame(width: 8, height: 8)
                                             .opacity(meetingViewModel.isToday(date: day) ? 1 : 0)
                                     }
                                     // Capsule Shape
                                     .foregroundStyle(meetingViewModel.isToday(date: day) ? .primary : .secondary)
                                     .foregroundColor(meetingViewModel.isToday(date: day) ? .black : .gray)
                                     .frame(width: 45, height: 90)
                                     .background(
                                     
                                         ZStack{
                                             if meetingViewModel.isToday(date: day){
                                                 Capsule()
                                                     .fill(Color("BlueB"))
                                                     .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                             }
                                         }
                                         
                                     )
                                     .contentShape(Capsule())
                                     .onTapGesture {
                                         // update current day
                                         withAnimation{
                                             meetingViewModel.currentDate = day
                                         }
                                     }
                                     
                                 }
                         
                             }
                             .padding(.horizontal)
                         }
                     
                 }
                 .ignoresSafeArea(.container, edges: [.top] )
                // vertical scroll view to display meetings
                    ScrollView(.vertical){
                         MeetingsView()
                             .frame(
                                 minWidth: 0,
                                 maxWidth: .infinity,
                                 minHeight: 0,
                                 maxHeight: .infinity,
                                 alignment: .topLeading
                               )
                    }
                    .background(.white)
                    .cornerRadius(25)
                    .ignoresSafeArea(.container, edges: [.bottom] )
                    
             }
             .preferredColorScheme(.light)
         
         // MARK: Meeting Details Sheet
         .bottomSheet(bottomSheetPosition: $bottomSheetPosition, options: [BottomSheet.Options.allowContentDrag,.tapToDismiss, .swipeToDismiss, .backgroundBlur(effect: .dark), .animation(.linear), .cornerRadius(12), .dragIndicatorColor(.gray), .background(AnyView(Color.white))], content: {
             // see view under "Views" folder
             MeetingDetails(coordinateRegion: $coordinateRegion,showingSheet: $showingSheet, meeting: self.meetingViewModel.filteredMeetings?.filter{$0.id == meetingViewModel.selectedMeeting?.id}.first ?? Meeting(id: "1", host: "none", title: "none", datetime_start: Date(), datetime_end: Date(),type: "none", location: "none", attendees: ["11" : "none"], agenda: "none", latitude: "unavailable", longitude: "unavailable"), showingPASheet: $showingPASheet)

         })
         // MARK: Attendees List Sheet
         .sheet(isPresented: $showingSheet) {
             // see view under "Views" folder
             MeetingAttendeesListView(meeting: self.meetingViewModel.filteredMeetings?.filter{$0.id == meetingViewModel.selectedMeeting?.id}.first ?? Meeting(id: "1", host: "none", title: "none", datetime_start: Date(), datetime_end: Date(),type: "none", location: "none", attendees: ["11" : "none"], agenda: "none", latitude: "unavailable", longitude: "unavailable"))
         }
         // MARK: Take Participants Attendance Sheet
         .sheet(isPresented: $showingPASheet, content: {
             
             // display Participants Attendance view
             ParticipantsAttendance(meeting: meetingViewModel.selectedMeeting ?? Meeting(id: "1", host: "none", title: "none", datetime_start: Date(), datetime_end: Date(),type: "none", location: "none", attendees: ["11" : "none"], agenda: "none", latitude: "unavailable", longitude: "unavailable"))
             
         })
         .background(
             LinearGradient(colors: [Color(red: 0.753, green: 0.91, blue: 0.98),Color(red: 0.639, green: 0.878, blue: 0.988)], startPoint: .top, endPoint: .bottom)
         )
     }
     // Meetings View
     func MeetingsView() -> some View {
         
         LazyVStack(spacing: 20){
             
             if let meetings = meetingViewModel.filteredMeetings {
                 
                 if meetings.isEmpty {
                     Text("No Tasks Found!")
                         .font(.system(size: 16))
                         .fontWeight(.light)
                         .offset(y:100)
                 } else {
                     
                     if meetings.count > 1 {
                         Text("\(meetings.count) Meetings")
                             .fontWeight(.medium)
                             .hLeading()
                             .foregroundColor(Color("BlueA"))
                             .padding(.leading, 10)
                     } else {
                         Text("\(meetings.count) Meeting")
                             .fontWeight(.medium)
                             .hLeading()
                             .foregroundColor(Color("BlueA"))
                             .padding(.leading, 10)
                     }
                     
                     ForEach(meetings){ meeting in
                         Button {
                             meetingViewModel.selectedMeeting = meeting
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
                 }
             } else {
                 ProgressView()
                     .offset(y: 100)
             }
         }
         .padding()
         .padding(.top)
         
         // update meeting
         .onChange(of: meetingViewModel.currentDate){ newValue in
             meetingViewModel.filterTodayMeetings()
         }
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
     
     // building the header view
     func HeaderView() -> some View {
         HStack(spacing: 25){
             Button(action: {
                       // Go to Calendar Grid
                 withAnimation {
                     viewRouter.currentPage = .CalendarGrid
                 }
                        
                     }, label: {
                         Image(systemName: "calendar")
                             .resizable()
                             .foregroundColor(Color(.gray))
                             .frame(width: 20, height: 20)
                 })
             
             Button(action: {
                // In Calendar Timeline
             }, label: {
                 Image(systemName: "list.bullet")
                     .resizable()
                     .foregroundColor(Color(.gray))
                     .frame(width: 18, height: 18)
                     .overlay(
                         RoundedRectangle(cornerRadius: 25)
                             .fill(.white.opacity(0.4))
                             .frame(width: 40, height: 35)
                     )
             })
             
             Text("\(meetingViewModel.currentDate.formatted(.dateTime.month(.wide)))")
             .font(.title2)
             .fontWeight(.semibold)
             .foregroundColor(.gray)
             .hCenter()
             
             Spacer()
             Button(action: {
             
             // Generate Meeting
             }, label: {
                 Image(systemName: "plus")
                     .resizable()
                     .foregroundColor(Color(.gray))
                     .frame(width: 20, height: 20)
             })
             .padding(.trailing, 7)
         }
         .hLeading()
         .padding([.leading],19)
         .padding([.trailing ,.bottom],10)
         .padding([.top],55)
     }
    
 }

struct CalendarTimeline_Previews: PreviewProvider {
    static var previews: some View {
        CalendarTimeline(viewRouter: CalendarViewRouterHelper())
    }
}

// MARK: UI Design Helper Functions
extension View {
    
    func hLeading() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func hTrailing() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .trailing)
    }
    
    func hCenter() -> some View {
        self
            .frame(maxWidth: .infinity, alignment: .center)
    }
    // safe area
    func getSafeArea() -> UIEdgeInsets {
       
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
}
