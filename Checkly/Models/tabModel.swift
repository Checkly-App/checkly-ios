//
//  tabModel.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 06/08/1443 AH.
//

import Foundation

class tabModel: ObservableObject{
    
    @Published var isMessagesViewLoaded = false
    @Published var isCalendarViewLoaded = false
    @Published var isStatisticsViewLoaded = false
    @Published var isServicesLoaded = false
    
    init(){
        print("Home is loaded")
    }
    
    func loadMessages(){
        print("Messages loaded")
        isMessagesViewLoaded = true
    }
    
    func loadCalendar(){
        print("Calendar loaded")
        isCalendarViewLoaded = true
    }
    
    func loadStatistics(){
        print("Statistics loaded")
        isStatisticsViewLoaded = true
    }
    
    func loadServices(){
        print("Services loaded")
        isServicesLoaded = true
    }
}

