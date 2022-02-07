//
//  DateValueModel.swift
//  Checkly
//
//  Created by a w on 07/02/2022.
//

import Foundation

struct DateValueModel: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
