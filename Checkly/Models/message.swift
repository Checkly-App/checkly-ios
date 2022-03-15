

//
//  message.swift
//  messages
//
//  Created by Noura Alsulayfih on 08/07/1443 AH.
//
import Foundation

struct message: Identifiable {
    
    var id: String
    let documentID: String
    let fromID, toID, text: String
}
