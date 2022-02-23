//
//  recentMessage.swift
//  messages
//
//  Created by Noura Alsulayfih on 07/07/1443 AH.
//

import Foundation
import ScreenTime
import Firebase

struct recentMessage: Identifiable {
 
    let id: String
    let fromID, toID, text: String
    let username: String
    let timestamp: Date
    let senderName: String
    let receiverName: String
    let photoURL: String

}
