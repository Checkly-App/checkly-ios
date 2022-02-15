//
//  MeetingDetails.swift
//  Checkly
//
//  Created by a w on 13/02/2022.
//

import SwiftUI

struct MeetingDetails: View {
    
    var meeting: Meeting
    
    var body: some View {
        ZStack{
            
            VStack(){
                Text(meeting.title)
                    .font(.system(size: 32, weight: .bold))
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.leading)
                    .hLeading()
                    .padding([.leading], 10)
                    .padding([.bottom], 27)
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color(.gray))
                        .frame(height: 630)
                    VStack {
                        //host name
                        Text(meeting.type)
                        Text(meeting.dateTime.formatted(date: .omitted, time: .shortened))
                        Text(meeting.dateTime.formatted(date: .abbreviated, time: .omitted))
                        Text(meeting.location)
                        Text(meeting.agenda)
                        // attendees names
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            .edgesIgnoringSafeArea(.bottom)
            
        }
    }
}

struct MeetingDetails_Previews: PreviewProvider {
    static var previews: some View {
        MeetingDetails(meeting: Meeting(id: "1", host: "1111", title: "Cloud Security Engineers Meeting", dateTime: .init(timeIntervalSince1970: 1644213600), type: "Online", location: "www.zoom.com", attendees: ["1122":"Accepted"], agenda: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."))
    }
}
