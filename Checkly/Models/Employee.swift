//
//  Employee.swift
//  messages
//
//  Created by Norua Alsalem on 06/02/2022.
//

import Foundation

struct Employee: Identifiable, Codable {
    var id: String
    var name: String
    var department: String
    var photoURL: String
}
