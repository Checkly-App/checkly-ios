//
//  CalendarTimeline.swift
//  Checkly
//
//  Created by a w on 07/02/2022.
//

import SwiftUI
import MapKit
import FirebaseStorage
import SDWebImageSwiftUI
import BottomSheet

struct CalendarTimeline: View {
    
     @ObservedObject var meetingViewModel: MeetingViewModel = MeetingViewModel()
     @Namespace var animation
     // to switch between screens
     @StateObject var viewRouter: CalendarViewRouterHelper
     // for bottom sheet
     @State private var bottomSheetPosition: BottomSheetPosition = .hidden
     // for images
     @State private var imageURL = URL(string: "")
     // for attendees sheet
     @State private var showingSheet = false
     // for map view
     @State private var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 0.0,longitude: 0.0),span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
    
     var body: some View {
         
         // horizontal scroll view to select dates
         ScrollView(.vertical, showsIndicators: false){
             
             VStack(spacing: 15){
                 
                 HeaderView()
                 
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
                     
                 }
             }
             .preferredColorScheme(.light)
         }
         .bottomSheet(bottomSheetPosition: $bottomSheetPosition, options: [BottomSheet.Options.allowContentDrag,.tapToDismiss, .swipeToDismiss, .backgroundBlur(effect: .dark), .animation(.linear), .cornerRadius(12), .dragIndicatorColor(.gray), .background(AnyView(Color.white))], content: {
             
             // see function below
             MeetingDetailsView(meeting: meetingViewModel.selectedMeeting ?? Meeting(id: "1", host: "none", title: "none", date: Date(), type: "none", location: "none", attendees: ["11" : "none"], agenda: "none", end_time: "9:45 AM", start_time: "9:00 AM", latitude: "unavailable", longitude: "unavailable"))

         })
         .sheet(isPresented: $showingSheet) {
             Rectangle()
                 .fill(.gray)
                 .frame(width: 38, height: 5)
                 .cornerRadius(35)
                 .padding(.top, 10)
             NavigationView {
                 List(meetingViewModel.meetingAttendeesArray(meeting: (meetingViewModel.selectedMeeting)!)){ attendee in
                     HStack{
                         // attendee image
                         if URL(string: attendee.imgToken) == URL(string: "null"){
                             Image(systemName: "person.crop.circle.fill")
                                 .resizable()
                                 .aspectRatio(contentMode: .fill)
                                 .foregroundColor(.gray)
                                 .frame(width: 50, height: 50)
                                 .clipShape(Circle())
                         } else {
                             WebImage(url: URL(string: attendee.imgToken))
                                 .resizable()
                                 .indicator(Indicator.activity)
                                 .aspectRatio(contentMode: .fill)
                                 .frame(width: 50, height: 50)
                                 .clipShape(Circle())
                                 .onAppear(perform: {loadImageFromFirebase(imgurl: attendee.imgToken)})
                         }
                         VStack{
                             // attendee name
                             Text(attendee.name)
                                 .font(.system(size: 20, weight: .medium))
                             // attendee position
                         }
                     }
                 }
                 .listStyle(.plain)
                 .navigationBarTitle("Attendees")

             }
         }
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
                     ForEach(meetings){ meeting in
                         Button {
                             meetingViewModel.selectedMeeting = meeting
                             coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: Double(meetingViewModel.selectedMeeting?.latitude ?? "0.0") ?? 0.0,longitude: Double(meetingViewModel.selectedMeeting?.longitude ?? "0.0") ?? 0.0),span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
                             
                             withAnimation{
                                 bottomSheetPosition = .middle
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
             .background(Color.white)
     }
    
    func MeetingDetailsView(meeting: Meeting) -> some View {
        VStack(spacing: 20) {
            HStack(alignment: .top) {
                Circle()
                    .fill(meeting.type == "Online" ? Color("BlueA") : Color("Purple"))
                    .frame(width: 10, height: 10)
                    .padding(.top, 10)
                Text(meeting.title)
                    .font(.system(size: 25, weight: .bold))
                    .fontWeight(.semibold)
                    .hLeading()
                ZStack{
                    RoundedRectangle(cornerRadius: 25)
                        .fill(meeting.type == "Online" ? Color("BlueA").opacity(0.2) : Color("Purple").opacity(0.2))
                                .frame(width: 75, height: 38)
                    Text(meeting.type)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(meeting.type == "Online" ? Color("BlueA"): Color("Purple"))
                        }
                        .padding(.trailing, 10)
                    }
                    .padding([.top], 15)
                    .padding([.leading], 15)
            // Host name
            Text("By: \(meetingViewModel.getHostName(hostID: meeting.host))")
                 .font(.system(size: 16, weight: .semibold))
                 .foregroundColor(.gray)
                 .hLeading()
                 .padding([.leading], 15)
            // MARK: Attendees images
            HStack(spacing: -10){
                if meetingViewModel.meetingAttendeesArray(meeting: meeting).count != 0 {
                   
                 // if attendees are less than 7 display all their images, else display 7 only
                  if meetingViewModel.meetingAttendeesArray(meeting: meeting).count < 7 {
                        
                      ForEach(meetingViewModel.meetingAttendeesArray(meeting: meeting)){ attendee in
                        if URL(string: attendee.imgToken) == URL(string: "null"){
                            Button(action: {
                                      showingSheet.toggle()
                                  }) {
                                      Image(systemName: "person.crop.circle.fill")
                                          .resizable()
                                          .aspectRatio(contentMode: .fill)
                                          .foregroundColor(.gray)
                                          .frame(width: 50, height: 50)
                                          .clipShape(Circle())

                                  }
                        } else {
                            Button(action: {
                                      showingSheet.toggle()
                                  }) {
                                      WebImage(url: URL(string: attendee.imgToken))
                                          .resizable()
                                          .indicator(Indicator.activity)
                                          .aspectRatio(contentMode: .fill)
                                          .frame(width: 50, height: 50)
                                          .clipShape(Circle())
                                          .onAppear(perform: {loadImageFromFirebase(imgurl: attendee.imgToken)})
                                  }
                        }
                      }
                      
                } else {
                    // display only 7 images and the 8th will be (+ plus)
                    ForEach(1...7, id: \.self){ index in
                        
                        // attendee does not have an image
                        if URL(string: meetingViewModel.meetingAttendeesArray(meeting: meeting)[index].imgToken) == URL(string: "null"){
                            Button(action: {
                                      showingSheet.toggle()
                                  }) {
                                      Image(systemName: "person.crop.circle.fill")
                                          .resizable()
                                          .aspectRatio(contentMode: .fill)
                                          .foregroundColor(.gray)
                                          .frame(width: 50, height: 50)
                                          .clipShape(Circle())

                                  }
                        }
                        // attendee have an image
                        else {
                            Button(action: {
                                      showingSheet.toggle()
                                  }) {
                                      WebImage(url: URL(string: meetingViewModel.meetingAttendeesArray(meeting: meeting)[index].imgToken))
                                          .resizable()
                                          .indicator(Indicator.activity)
                                          .aspectRatio(contentMode: .fill)
                                          .frame(width: 50, height: 50)
                                          .clipShape(Circle())
                                          .onAppear(perform: {loadImageFromFirebase(imgurl: meetingViewModel.meetingAttendeesArray(meeting: meeting)[index].imgToken)})
                                  }
                        }
                    }
                    // display + with the number of remaining attendees
                    Button(action: {
                              showingSheet.toggle()
                          }) {
                              ZStack {
                                  Circle()
                                      .fill(Color(red: 0.283, green: 0.283, blue: 0.283))
                                      .frame(width: 50, height: 50)
                                  Text("+\(meetingViewModel.meetingAttendeesArray(meeting: meeting).count - 7)")
                                      .foregroundColor(.white)
                                      .fontWeight(.semibold)
                              }

                          }
                }

                }
            }
            .hLeading()
            .padding([.leading], 15)
            
            Divider()
            HStack(spacing: 13) {
                Image( systemName: "clock")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("\(meeting.start_time) - \(meeting.end_time)")
                    .font(.system(size: 19, weight: .semibold))
                    
            }
            .foregroundColor(.gray)
            .hLeading()
            .padding([.leading], 15)
            .padding([.top], 5)
            
            // if current user is the host of the meeting, show edit button
            
            HStack(spacing: 13) {
                Image( systemName: "calendar")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(meeting.date.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 19, weight: .semibold))
                    
                }
                .foregroundColor(.gray)
                .hLeading()
                .padding([.leading], 15)
                .padding([.top], 5)
            
            // Fix multiline image issue
            // Agenda
            HStack(spacing: 13) {
                Image( systemName: "text.alignleft")
                    .resizable()
                    .frame(width: 19, height: 19)
                Text(meeting.agenda)
                    .font(.system(size: 19, weight: .semibold))
                    .multilineTextAlignment(.leading)
                    .padding(.trailing, 5)
                
                }
                .foregroundColor(.gray)
                .hLeading()
                .padding([.leading], 15)
                .padding([.top], 5)
            
            // location
            HStack(spacing: 13) {
                Image( systemName: "mappin.and.ellipse")
                    .resizable()
                    .foregroundColor(Color(.gray))
                    .frame(width: 19, height: 21)
                if meeting.type == "Online" {
                    Link("\(meeting.location)",destination: URL(string: "\(meeting.location)")!)
                                .font(.system(size: 19, weight: .semibold))
                } else {
                    Text(meeting.location)
                        .font(.system(size: 19, weight: .semibold))
                        .foregroundColor(.gray)
                        }
                    }
                    .hLeading()
                    .padding([.leading], 15)
                    .padding([.top], 5)
         // Map view if available
            if meeting.latitude != "unavailable" && meeting.longitude != "unavailable" {
                
                Map(coordinateRegion: $coordinateRegion, annotationItems: [AnnotatedItem(coordinate: .init(latitude: Double(meeting.latitude) ?? 0.0, longitude: Double(meeting.longitude) ?? 0.0) )]){ item in
                    MapMarker(coordinate: item.coordinate, tint: .red)
                    
                }
                        .frame(width: 340, height: 140, alignment: .center)
                        .cornerRadius(10)
            }

        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
          )
    }
    
    func loadImageFromFirebase(imgurl: String) {
           let storage = Storage.storage().reference(forURL: imgurl)
           storage.downloadURL { (url, error) in
               if error != nil {
                   print((error?.localizedDescription)!)
                   return
               }
               print("Download success")
               self.imageURL = url!
           }
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
