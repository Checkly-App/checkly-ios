//
//  Employee.swift
//  Checkly
//
//  Created by Norua Alsalem on 25/03/2022.
//

import Foundation

struct Employee: Identifiable, Hashable, Equatable{
    var employee_id: String
    var address: String
    var birthdate: String
    var department: String
    var email: String
    var id: String
    var gender: String
    var name: String
    var national_id: String
    var phone_number: String
    var position: String
    var photoURL: String
}
