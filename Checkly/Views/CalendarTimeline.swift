//
//  CalendarTimeline.swift
//  Checkly
//
//  Created by a w on 07/02/2022.
//

import SwiftUI

struct CalendarTimeline: View {
    
     @StateObject var meetingViewModel: MeetingViewModel = MeetingViewModel()
     @Namespace var animation
     // to switch between screens
     @StateObject var viewRouter: CalendarViewRouterHelper
     
     var body: some View {
         
         // horizontal scroll view to select dates
         ScrollView(.vertical, showsIndicators: false){
             
             LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]){
                 
                 Section {
                     
                     // MARK: Current Week View
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
                     
                     MeetingsView()
                     
                 } header: {
                     HeaderView()
                 }
             }
             .preferredColorScheme(.light)
         }
         .ignoresSafeArea(.container, edges: .top)
     }
     // Meetings View
     func MeetingsView() -> some View {
         
         LazyVStack(spacing: 20){
             
 //            let colors: [Color] = [Color("Orange"), Color("Pink"), Color("BlueA"), Color("Purple")]
             
             if let meetings = meetingViewModel.filteredMeetings {
                 
                 if meetings.isEmpty {
                     Text("No Tasks Found!")
                         .font(.system(size: 16))
                         .fontWeight(.light)
                         .offset(y:100)
                 } else {
                     ForEach(meetings){ meeting in
                         MeetingCardView(meeting: meeting)
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
                     Text(meeting.date.formatted(date: .omitted, time: .shortened))
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
     
     // buliding the header view
     func HeaderView() -> some View {
         HStack(spacing: 25){
                     Button(action: {
                       // Go to Calendar Grid
                         viewRouter.currentPage = .CalendarGrid
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
                                     .fill(Color("BlueA").opacity(0.3))
                                     .frame(width: 40, height: 35)
                             )
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
                 }
             .hLeading()
             .padding()
             .padding(.top, getSafeArea().top)
             .background(Color.white)
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
