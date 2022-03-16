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
    
    @State private var showingAlert = false
    
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
                     
                        // Pop up alert if user did not mark any attendee as "attended"
                        if !attendeesSelected(){
                            
                            showingAlert = true
                        
                        } else {
                            // this loops through unselected attendees
                            for attendee in attendees {
                                if attendee.value != "attended" && attendee.value != "absent" {
                                    attendees[attendee.key] = "absent"
                                }
                            }
                            // insert attendees dictionary into DB at specified meeting id location
                            meetingViewModel.takeMeetingAttendance(meeting_id: meeting.id, attendeesDictionary: attendees)
                            
                            // setting up selected meeting in order to update it
                            meetingViewModel.selectedMeeting = meeting
                            
                          dismiss()
                        }
                        
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
            
             .navigationBarTitle("Take Attendance")
             .toolbar {
                 Button("Cancel"){
                     dismiss()
                 }
             }
             .preferredColorScheme(.light)
        }
        
        .alert("Oops..!", isPresented: $showingAlert, actions: {
            Button("No", role: .cancel) { }
            Button("Yes") {
                for attendee in attendees {
                    if attendee.value != "attended" && attendee.value != "absent" {
                        attendees[attendee.key] = "absent"
                    }
                }
                // insert attendees dictionary into DB at specified meeting id location
                meetingViewModel.takeMeetingAttendance(meeting_id: meeting.id, attendeesDictionary: attendees)
                
                // setting up selected meeting in order to update it
                meetingViewModel.selectedMeeting = meeting
                
              dismiss()
            }
        }, message: {
            Text("You did not select any participant, this will mark all participants as \"Absent\", Do you want to proceed?")
        })
        
        .onAppear {
            attendees = meeting.attendees
        }
    }
    
    func attendeesSelected() -> Bool{
        
        var i = 0
        
        for attendee in attendees {
            if attendee.value != "attended" {
                i+=1
            }
        }
        // this means the host did not mark any participant as "attended"
        if attendees.count == i{
            return false
        }
            
        return true
    }
    
}

struct ParticipantsAttendance_Previews: PreviewProvider {
    static var previews: some View {
        ParticipantsAttendance(meeting: Meeting(id: "1", host: "e0a6ozh4A0QVOXY0tyiMSFyfL163", title: "Cloud Security Engineers Meeting", datetime_start: Date(), datetime_end: Date() ,type: "On-site", location: "STC HQ, IT Meeting Room", attendees: ["VsWRopBPLQYNMXlL5u5mkcGETze2" : "accepted"], agenda: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua", latitude: "24.7534673", longitude: "46.6920362"))
       
    }
}
