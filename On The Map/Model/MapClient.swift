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
        static let uniqueKey = "2222"
        static var objectID = ""
    }
    
    enum Endpoints {
        static let baseStudentLocation = "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let baseSession = "https://onthemap-api.udacity.com/v1/session"
        
        case getStudentLocation
        case getSessionID
        case postStudentLocation
        case updateStudentLocation
        case deleteSession
        
        var stringValue: String {
            switch self {
            case .getStudentLocation: return Endpoints.baseStudentLocation + "?order=-updatedAt"
            case .getSessionID: return Endpoints.baseSession
            case .postStudentLocation: return Endpoints.baseStudentLocation
            case .updateStudentLocation: return Endpoints.baseStudentLocation + "/\(Auth.objectID)"
            case .deleteSession: return Endpoints.baseSession
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
                print("Session ID: \(Auth.sessionID)")
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
//        let body = body
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
        
        let body = StudentLocation(objectId: "", uniqueKey: Auth.uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: lat, longitude: lon)
        taskForPostStudentLocation(body: body) { (response, error) in
            if let response = response {
                print("ObjectID: \(response.objectId)")
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    // 4. - Update exisiting location with PUT method
    
    
    class func taskForPutStudentLocation(body: StudentLocation, completion: @escaping(LocationUpdateResponse?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.updateStudentLocation.url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                print("data error: \(error!)")
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(LocationUpdateResponse.self, from: data)
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
    
    class func updateStudentLocation(firstName: String, lastName: String, mapString: String, mediaURL: String, lat: Double, lon: Double, completion: @escaping (Bool, Error?) -> Void) {
        let body = StudentLocation(objectId: Auth.objectID, uniqueKey: Auth.uniqueKey, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: lat, longitude: lon)
        taskForPutStudentLocation(body: body) { (response, error) in
            if let response = response {
                print("Location Update Success 1: \(response.updatedAt)")
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } else {
                print(error!)
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
    }
    
    
    // 5. - Task for deleting a session and logout
    
    class func logout(completion: @escaping() -> Void) {
        var request = URLRequest(url: Endpoints.deleteSession.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                print(error?.localizedDescription)
                return
            }
            
            let range = 5..<data!.count
            let newData = data?.subdata(in: range)
            print("Logout: \(String(data: newData!, encoding: .utf8)!)")
            Auth.sessionID = ""
            completion()
        }
        task.resume()
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
