//
//  LoginResponse.swift
//  On The Map
//
//  Created by Sean Williams on 09/08/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import Foundation

struct Account: Codable {
    let key: String
}

struct Session: Codable {
    let ID: String

    enum CodingKeys: String, CodingKey {
        case ID = "id"
    }
}

struct LoginResponse: Codable {
    let account: Account
    let session: Session

}


