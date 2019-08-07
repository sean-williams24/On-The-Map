//
//  MapClient.swift
//  On The Map
//
//  Created by Sean Williams on 07/08/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import Foundation
import UIKit


class MapClient {
    
    enum Endpoints {
        static let baseStudentLocation = "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let baseSession = "https://onthemap-api.udacity.com/v1/session"
        
        case getStudentLocation
        
        var stringValue: String {
            switch self {
            case .getStudentLocation: return Endpoints.baseStudentLocation
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getStudentLocations(completion: @escaping ([StudentLocation], Error?) -> Void) {
        let request = URLRequest(url: Endpoints.getStudentLocation.url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data  else {
                completion([], error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseDict = try decoder.decode([String:[StudentLocation]].self, from: data)
                let responseObject = responseDict.values.map({$0})
                let flattened = Array(responseObject.joined())
                completion(flattened, nil)
            } catch {
                print(error)
            }
        }
        task.resume()
    }

    
    
}
