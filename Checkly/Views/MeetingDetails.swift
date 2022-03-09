//
//  MeetingDetails.swift
//  Checkly
//
//  Created by a w on 04/03/2022.
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
                // type
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
            
            // meeting location
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
            if meeting.latitude != "0" && meeting.longitude != "0" {
                
                Map(coordinateRegion: $coordinateRegion, annotationItems: [AnnotatedItem(coordinate: .init(latitude: Double(meeting.latitude) ?? 0.0, longitude: Double(meeting.longitude) ?? 0.0) )]){ item in
                    MapMarker(coordinate: item.coordinate, tint: Color("BlueA"))
                    
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
   
    @State static private var coordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 24.7534673 ,longitude: 46.6920362),span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
    @State static private var showingSheet = false
    
    static var previews: some View {
        MeetingDetails(coordinateRegion: $coordinateRegion, showingSheet: $showingSheet, meeting: Meeting(id: "1", host: "e0a6ozh4A0QVOXY0tyiMSFyfL163", title: "Cloud Security Engineers Meeting", datetime_start: Date(), datetime_end: Date() ,type: "On-site", location: "STC HQ, IT Meeting Room", attendees: ["VsWRopBPLQYNMXlL5u5mkcGETze2" : "accepted"], agenda: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", latitude: "24.7534673", longitude: "46.6920362"))
    }
}
