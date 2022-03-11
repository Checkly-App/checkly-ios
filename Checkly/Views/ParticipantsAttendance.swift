//
//  ParticipantsAttendance.swift
//  Checkly
//
//  Created by a w on 11/03/2022.
//

import SwiftUI

struct ParticipantsAttendance: View {
    
    @ObservedObject var meetingViewModel : MeetingViewModel = MeetingViewModel()
    
    @State private var selectedRows = Set<attendee>()
    
    @State private var attendees: [String : String] = [:]
    
    var meeting : Meeting
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationView{
            
            ZStack{
                
                VStack {
                    List(meetingViewModel.meetingAttendeesArray(meeting: meeting), selection: $selectedRows){ participant in
                        ParticipantRow(selectedRows: $selectedRows, attendeesDictionary: $attendees, attendee: participant)
                    }
                }
                
                VStack {
                    Spacer()
                    
                    // Save button
                    Button{
                     
                        // this loops through unselected attendees
                        for attendee in attendees {
                            if attendee.value != "attended" && attendee.value != "absent" {
                                attendees[attendee.key] = "absent"
                            }
                        }
                        // insert attendees dictionary into DB at specified meeting id location
                        meetingViewModel.takeMeetingAttendance(meeting_id: meeting.id, attendeesDictionary: attendees)
                        
                      print(selectedRows)
                      print(attendees)
                      dismiss()
                     } label: {
                         Text("Save")
                            .font(.system(size: 19, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 300)
                            .padding()
                            .background(
                                LinearGradient(colors: [Color(red: 0.337, green: 0.729, blue: 0.922),Color(red: 0.275, green: 0.631, blue: 0.953)], startPoint: .leading, endPoint: .trailing)
                             )
                            .cornerRadius(10.0)
                     }
                }
            }
            
             .navigationBarTitle("Participants")
        }.onAppear {
            attendees = meeting.attendees
        }
    }
}

struct ParticipantsAttendance_Previews: PreviewProvider {
    static var previews: some View {
        ParticipantsAttendance(meeting: Meeting(id: "1", host: "e0a6ozh4A0QVOXY0tyiMSFyfL163", title: "Cloud Security Engineers Meeting", datetime_start: Date(), datetime_end: Date() ,type: "On-site", location: "STC HQ, IT Meeting Room", attendees: ["VsWRopBPLQYNMXlL5u5mkcGETze2" : "accepted"], agenda: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", latitude: "24.7534673", longitude: "46.6920362"))
       
    }
}
