//
//  chatMessage.swift
//  messages
//
//  Created by Norua Alsalem on 13/02/2022.
//

import Foundation

//// i have to move this struct to models file
struct chatMessage: Identifiable {

    var id: String { documentID }

    let documentID: String
    let fromID, toID, text: String

    init(documentID: String, data: [String: Any]) {
        self.documentID = documentID
        self.fromID = data["fromID"] as? String ?? ""
        self.toID = data["toID"] as? String ?? ""
        self.text = data["text"] as? String ?? ""
    }
}
