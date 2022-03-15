//
//  Employee.swift
//  Checkly
//
//  Created by Norua Alsalem on 15/03/2022.
//

import Foundation

struct Employee: Identifiable, Codable {
    var id: String
    var name: String
    var department: String
    var photoURL: String
}

