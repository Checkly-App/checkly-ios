//
//  AnnotatedItemModel.swift
//  Checkly
//
//  Created by a w on 28/02/2022.
//

import Foundation
import CoreLocation

struct AnnotatedItem: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}
