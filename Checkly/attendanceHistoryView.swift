//
//  attendanceHistoryView.swift
//  Checkly
//
//  Created by Norua Alsalem on 02/03/2022.
//

import SwiftUI

struct attendanceHistoryView: View {
    
    @State private var fromDate = Date()
    @State private var toDate = Date()
    
    var body: some View {
        
        
        // Date Pickers
        VStack {
        DatePicker("From Date", selection: $fromDate, in: ...Date() , displayedComponents: .date).padding()
        
        DatePicker("To Date", selection: $toDate, in: ...Date() , displayedComponents: .date).padding()
        }
        
        // Resulting Attendaces
        
        
        
        
    }
}

struct attendanceHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        attendanceHistoryView()
    }
}
