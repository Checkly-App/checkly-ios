//
//  Leave.swift
//  Checkly
//
//  Created by Norua Alsalem on 25/03/2022.
//

import Foundation


struct Leave: Identifiable, Hashable {
    var start_date: String
    var end_date: String
    var status: String
    var notes: String
    var document: String
    var id: String
    var type: String
}
