//
//  LoginModel.swift
//  Checkly
//
//  Created by 🐈‍⬛ on 01/02/2022.
//

import Foundation

class Credentials: Codable {
    var email: String = ""
    var password: String = ""
    
    func encoded() -> String {
        let encoder = JSONEncoder()
        let credentialsData = try! encoder.encode(self)
        return String(data: credentialsData, encoding: .utf8)!
    }
    
    static func decode(_ credentialsString: String) -> Credentials {
        let decoder = JSONDecoder()
        let jsonData = credentialsString.data(using: .utf8)
        return try! decoder.decode((Credentials.self), from: jsonData!)
    }
}
