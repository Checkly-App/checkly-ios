//
//  Leave.swift
//  Checkly
//
//  Created by Norua Alsalem on 08/04/2022.
//

import Foundation


struct Leave: Identifiable, Hashable, Equatable {
    var start_date: String
    var end_date: String
    var status: String
    var notes: String
    var document: String
    var id: String
    var type: String
    var employee_id: String
    var employee_name: String
    var photoURL: String
}
