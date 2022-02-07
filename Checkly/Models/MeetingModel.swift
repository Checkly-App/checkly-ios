//
//  MeetingModel.swift
//  Checkly
//
//  Created by a w on 07/02/2022.
//

import Foundation

struct Meeting: Identifiable {
    
    var id: String
    var meeting_id: String
    var host: String
    var title: String
    var dateTime: Date
//    var date: Date
//    var time: String
    var type: String
    // location is a newly added attr
    var location: String
    var attendees: String
    var agenda: String
    
}
