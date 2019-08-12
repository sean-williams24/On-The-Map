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
    
    struct Auth {
        static var key = ""
        static var sessionID = ""
    }
    
    enum Endpoints {
        static let baseStudentLocation = "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let baseSession = "https://onthemap-api.udacity.com/v1/session"
        
        
        case getStudentLocation
        case getSessionID
        case postStudentLocation
        
        var stringValue: String {
            switch self {
            case .getStudentLocation: return Endpoints.baseStudentLocation + "?order=-updatedAt"
            case .getSessionID: return Endpoints.baseSession
            case .postStudentLocation: return Endpoints.baseStudentLocation
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }

    


    // - 1. Authentitace API request, obtain Session ID and store Session ID
    
    class func taskForloginRequest<ResponseType: Decodable>(username: String, password: String, url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: newData)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        taskForloginRequest(username: username, password: password, url: Endpoints.getSessionID.url, responseType: LoginResponse.self) { (response, error) in
            if let response = response {
                Auth.key = response.account.key
                Auth.sessionID = response.session.ID
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    
    // - 2. Download and parse student location data and store in studentLocationData array
    
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
    
    
    // 3. - Post a new student location
    
    class func taskForPostStudentLocation(body: StudentLocation, completion: @escaping (LocationPostResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = body
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(LocationPostResponse.self, from: data)
                DispatchQueue.main.async {
                    print(responseObject)
                    completion(responseObject, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    print(error)
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func postStudentLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, lat: Double, lon: Double, completion: @escaping (Bool, Error?) -> Void) {
        
        let body = StudentLocation(objectId: "", uniqueKey: "1111", firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: lat, longitude: lon)
        taskForPostStudentLocation(body: body) { (response, error) in
            if let response = response {
                print("ObjectID: \(response.objectId)")
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
        
}
    
    
    
    
    
    
    
    
    
    // Refactored (2) get student locations -
    class func getStudentLocations2(completion: @escaping ([StudentLocation], Error?) -> Void) {
        taskForGetRequest(url: Endpoints.getStudentLocation.url, response: [String:[StudentLocation]].self) { (response, error) in
            if let response = response {
                let studentLocations = response.values.map({$0})
                let flattenedArrays = Array(studentLocations.joined())
                completion(flattenedArrays, nil)
            } else {
                completion([], error)
            }
        }
    }
    
    
    class func taskForGetRequest<ResponseType: Decodable>(url: URL, response: ResponseType.Type, completion: @escaping (ResponseType?, Error?) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data  else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                print(error)
            }
        }
        task.resume()
    }
}
