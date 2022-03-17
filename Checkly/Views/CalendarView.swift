//
//  Calendar.swift
//  Checkly
//
//  Created by a w on 07/02/2022.
//

import SwiftUI

struct CalendarView: View {
    
    @StateObject var viewRouter: CalendarViewRouterHelper
    @State private var currentDate: Date = Date()
    
    var body: some View {
        switch viewRouter.currentPage {
        case .CalendarGrid:
                // Calendar Grid
                CalendarGridView(currentDate: $currentDate, viewRouter: viewRouter)
        case .CalendarTimeline:
            CalendarTimelineView(viewRouter: viewRouter)
        }
    }
}

