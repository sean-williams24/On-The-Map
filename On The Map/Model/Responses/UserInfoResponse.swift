//
//  UserInfoResponse.swift
//  On The Map
//
//  Created by Sean Williams on 16/08/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import Foundation

struct UserInfoResponse: Codable {
    let lastName: String
    let firstName: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
    }
}
