//
//  ContentView.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 01/02/2022.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @EnvironmentObject var authentication: Authentication
    
    var body: some View {
        
       
            servicesView()
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
