//
//  StudentInformation.swift
//  On The Map
//
//  Created by Sean Williams on 07/08/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import Foundation

struct StudentLocation: Codable, Equatable {
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Float
    let longitude: Float
    
//    enum CodingKeys: String, CodingKey {
//        case firstName
//        case lastName
//        case mediaURL
//        case latitude
//        case longitude
//    }
}
