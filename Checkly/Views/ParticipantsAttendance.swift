//
//  ParticipantsAttendance.swift
//  calendar
//
//  Created by a w on 11/03/2022.
//

import SwiftUI

struct ParticipantsAttendance: View {
    
    @ObservedObject var meetingViewModel : MeetingViewModel = MeetingViewModel()
    
    @State var selectedRows = Set<attendee>()

    var participants : [attendee]
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        
        NavigationView{
            
            ZStack{
                
                VStack {
                    List(participants, selection: $selectedRows){ participant in
                        ParticipantRow(attendee: participant, selectedRows: $selectedRows)
                    }
                }
                
                VStack {
                    Spacer()
                    // Save button
                    Button{
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
        }
    }
}

struct ParticipantsAttendance_Previews: PreviewProvider {
    static var previews: some View {
        ParticipantsAttendance(participants: [attendee(id: "e0a6ozh4A0QVOXY0tyiMSFyfL163", name: "Aleen AlSuhaibani", position: "Associate", imgToken: "null", status: "accepted")])
    }
}
