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
        Text(meeting.title)
    }
}

struct MeetingDetails_Previews: PreviewProvider {
    static var previews: some View {
        MeetingDetails(meeting: Meeting(id: "1", host: "1111", title: "Cloud Security Engineers Meeting", dateTime: .init(timeIntervalSince1970: 1644213600), type: "Online", location: "www.zoom.com", attendees: ["1122":"Accepted"], agenda: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."))
    }
}
