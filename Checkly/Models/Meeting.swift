//
//  Meeting.swift
//  Checkly
//
//  Created by  Lama Alshahrani on 03/08/1443 AH.
//

import Foundation

struct Meeting: Identifiable {
    
    var id: String
    var host: String
    var title: String
    var date: Date
    var type: String
    var location: String
    var attendees: [String:String]
    var agenda: String
    var end_time: Date
   
    var latitude: String
    var longitude: String
}
