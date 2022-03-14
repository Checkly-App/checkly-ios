//
//  MeetingDetails.swift
//  Checkly
//
//  Created by a w on 28/02/2022.
//

import SwiftUI
import MapKit
import FirebaseStorage
import SDWebImageSwiftUI

struct MeetingDetails: View {
    
    @ObservedObject var meetingViewModel : MeetingViewModel = MeetingViewModel()
    @Binding var coordinateRegion: MKCoordinateRegion
    // for attendees sheet
    @Binding var showingSheet: Bool
    var meeting: Meeting
    // for participants attendance (PA) sheet
    @Binding var showingPASheet: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            HStack(alignment: .top) {
                Circle()
                    .fill(meeting.type == "Online" ? Color("BlueA") : Color("Purple"))
                    .frame(width: 10, height: 10)
                    .padding(.top, 10)
                // Title
                Text(meeting.title)
                    .font(.system(size: 25, weight: .bold))
                    .fontWeight(.semibold)
                    .hLeading()
                // Type
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
                    .padding([.leading], 15)
            
            // Host name
            Text("By: \(meetingViewModel.getHostName(hostID: meeting.host))")
                 .font(.system(size: 16, weight: .semibold))
                 .foregroundColor(.gray)
                 .hLeading()
                 .padding([.leading], 15)
            
            // Attendees images
            HStack(spacing: -10){
                if meetingViewModel.meetingAttendeesArray(meeting: meeting).count != 0 {
                   
                 // if attendees are less than 7 display all their images, else display 7 only
                  if meetingViewModel.meetingAttendeesArray(meeting: meeting).count <= 7 {
                        
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
                    ForEach(0...6, id: \.self){ index in
                        
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
            // Time
            HStack(spacing: 13) {
                Image( systemName: "clock")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text("\(meeting.datetime_start.formatted(date: .omitted, time: .shortened)) - \(meeting.datetime_end.formatted(date: .omitted, time: .shortened))")
                    .font(.system(size: 19, weight: .semibold))
                
                // if current user is host show edit button
                if meetingViewModel.isHost(meeting: meeting){
                    Spacer()
                    Button{
                        // edit meeting
                    }label: {
                        Image(systemName: "pencil.circle")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(Color("BlueA"))
                            .padding(.trailing)
                    }
                }
                    
            }
            .foregroundColor(.gray)
            .hLeading()
            .padding([.leading], 15)
            .padding([.top], 5)
            
            // Date
            HStack(spacing: 13) {
                Image( systemName: "calendar")
                    .resizable()
                    .frame(width: 20, height: 20)
                Text(meeting.datetime_start.formatted(date: .abbreviated, time: .omitted))
                    .font(.system(size: 19, weight: .semibold))
                    
                }
                .foregroundColor(.gray)
                .hLeading()
                .padding([.leading], 15)
                .padding([.top], 5)
           
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
                .padding([.trailing], 7)

            // Location
            HStack(spacing: 13) {
                Image( systemName: "mappin.and.ellipse")
                    .resizable()
                    .foregroundColor(Color(.gray))
                    .frame(width: 19, height: 21)
                if meeting.type == "Online" && meeting.location.isValidURL{
                    if meeting.location.starts(with: "www"){
                        Link("\(meeting.location)",destination: URL(string: "https://\(meeting.location)")!)
                                    .font(.system(size: 19, weight: .semibold))
                    } else if meeting.location.starts(with: "https://"){
                        Link("\(meeting.location)",destination: URL(string: "\(meeting.location)")!)
                        .font(.system(size: 19, weight: .semibold))
                    } else {
                        Link("\(meeting.location)",destination: URL(string: "https://www.\(meeting.location)")!)
                                    .font(.system(size: 19, weight: .semibold))
                    }
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
            if meeting.latitude != "0" && meeting.longitude != "0" {
                
                Map(coordinateRegion: $coordinateRegion, annotationItems: [AnnotatedItem(coordinate: .init(latitude: Double(meeting.latitude) ?? 0.0, longitude: Double(meeting.longitude) ?? 0.0) )]){ item in
                    MapMarker(coordinate: item.coordinate, tint: Color("BlueA"))
                    
                }
                        .frame(width: 340, height: 140, alignment: .center)
                        .cornerRadius(10)
            }
            // (Only if current user is Host & the time has elapsed & attendance has not not been taken yet)
            // Take Participants attendance Button
            if(meetingViewModel.isHost(meeting: meeting) && meeting.datetime_start <= Date() && !meetingViewModel.meetingAttendanceTaken(meeting: meeting) ){
                Button{
                    showingPASheet.toggle()
                } label: {
                    Text("Take Attendance")
                       .font(.system(size: 19, weight: .semibold))
                       .foregroundColor(.white)
                       .frame(width: 300)
                       .padding()
                       .background(
                           LinearGradient(colors: [Color(red: 0.337, green: 0.729, blue: 0.922),Color(red: 0.275, green: 0.631, blue: 0.953)], startPoint: .leading, endPoint: .trailing)
                        )
                       .cornerRadius(10.0)
                }
                .padding(.top, 20)
            }
            // (Only if current user is host) if meeting has not started yet
            else if (meetingViewModel.isHost(meeting: meeting) && meeting.datetime_start > Date() ) {
                HStack{
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 25, height: 25)
                        .padding(.leading, 10)
                    Text("You can take participants attendance once the meeting starts")
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding([.top,.bottom, .leading],4)
                        .padding(.trailing, 15)
                }
                .foregroundColor(Color("Orange"))
                .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color("Orange"))
                    )
                .padding()
            }
            // (Only if current user is host) participants attendance have been taken
            else if (meetingViewModel.isHost(meeting: meeting) && meetingViewModel.meetingAttendanceTaken(meeting: meeting)){
                HStack{
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 25, height: 25)
                        .padding(.leading, 5)
                    Text("Attendance has been taken")
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding([.top,.bottom, .leading],4)
                        .padding(.trailing, 8)
                }
                .padding()
                .foregroundColor(Color(red: 0.173, green: 0.686, blue: 0.933))
                .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color(red: 0.173, green: 0.686, blue: 0.933))
                    )
            }
            
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
          )
    }// body
    
    func loadImageFromFirebase(imgurl: String) {
           let storage = Storage.storage().reference(forURL: imgurl)
           storage.downloadURL { (url, error) in
               if error != nil {
                   print((error?.localizedDescription)!)
                   return
               }
           }
    }
}

struct MeetingDetails_Previews: PreviewProvider {
   
    @State static private var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 24.7534673 ,longitude: 46.6920362),span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005))
    @State static private var showingSheet = false
    @State static private var showingPASheet = false

    static var previews: some View {
        MeetingDetails(coordinateRegion: $coordinateRegion, showingSheet: $showingSheet, meeting: Meeting(id: "1", host: "olU8zzFyDhN2cn4IxJKyIuXT5hM2", title: "Cloud Security Engineers Meeting", datetime_start: .init(timeIntervalSince1970: TimeInterval(1646892000)), datetime_end: .init(timeIntervalSince1970: TimeInterval(1646893800)),type: "On-site", location: "STC HQ, IT Meeting Room", attendees: ["kFfNyEYHLiONsrv7DmfmSafx7hZ2":"attended", "SsemeSIGH6Syjkf8ctO8No1I3hB3":"attended"], agenda: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", latitude: "24.7534673", longitude: "46.6920362"), showingPASheet: $showingPASheet)
    }
}

extension String {
    var isValidURL: Bool {
        guard !contains("..") else { return false }
    
        let head     = "((http|https)://)?([(w|W)]{3}+\\.)?"
        let tail     = "\\.+[A-Za-z]{2,3}+(\\.)?+(/(.)*)?"
        let urlRegEx = head+"+(.)+"+tail
    
        let urlTest = NSPredicate(format:"SELF MATCHES %@", urlRegEx)

        return urlTest.evaluate(with: trimmingCharacters(in: .whitespaces))
    }
}
