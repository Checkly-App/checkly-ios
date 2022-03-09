//
//  tabModel.swift
//  Checkly
//
//  Created by Noura Alsulayfih on 06/08/1443 AH.
//

import Foundation
import Firebase

class tabViewModel: ObservableObject{
    
    @Published var isMessagesViewLoaded = false
    @Published var isCalendarViewLoaded = false
    @Published var isStatisticsViewLoaded = false
    @Published var isServicesLoaded = false
    
    private var ref = Database.database().reference()
    
    
    init(){
        print("Home is loaded")
        loadHome()
    }
    
    func loadHome(){
        
        
        
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

