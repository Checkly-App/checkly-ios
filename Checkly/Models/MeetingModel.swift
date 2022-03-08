//
//  MeetingModel.swift
//  Checkly
//
//  Created by a w on 07/02/2022.
//

import Foundation

struct Meeting: Identifiable {
    
    var id: String
    var host: String
    var title: String
    var datetime_start: Date
    var datetime_end: Date
    var type: String
    var location: String
    var attendees: [String:String]
    var agenda: String
    var latitude: String
    var longitude: String
}
