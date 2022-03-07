//
//  attendance.swift
//  Checkly
//
//  Created by Norua Alsalem on 02/03/2022.
//

import Foundation

struct attendance: Identifiable, Hashable {
    var id: String
    var date: String
    var checkIn: String
    var checkOut: String
    var status: String
    var workingHours: String
}
