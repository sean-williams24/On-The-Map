//
//  NewLocationMapViewController.swift
//  On The Map
//
//  Created by Sean Williams on 07/08/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import UIKit
import MapKit

class NewLocationMapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var finishButton: UIButton!
    
    var location = ""
    var mediaURL = ""
    var latPost = 0.0
    var longPost = 0.0
    var name = ""
    var region = ""
    var country = ""
    let firstName = "Jack"
    let lastName = "Reacher"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finishButton.layer.cornerRadius = 20.0
        
        let long = CLLocationDegrees(longPost)
        let lat = CLLocationDegrees(latPost)
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(self.firstName) \(self.lastName): \(name) - \(region) / \(country)"
        annotation.subtitle = self.mediaURL
        
        self.mapView.addAnnotation(annotation)
        
        let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
        self.mapView.setRegion(viewRegion, animated: true)
        self.mapView.showsUserLocation = true
    }


    @IBAction func finishButtonTapped(_ sender: Any) {
        
        for student in StudentModel.studentLocationData {
            if student.uniqueKey == "2222" {
                MapClient.Auth.objectID = student.objectId
                // If student with key 2222 exists in array, call PUT method to replace record.
                MapClient.updateStudentLocation(firstName: firstName, lastName: lastName, mapString: location, mediaURL: "https://\(mediaURL)", lat: latPost, lon: longPost, completion: handlePutResponse(success:error:))
                return
            } else {
                MapClient.postStudentLocation(firstName: firstName, lastName: lastName, mapString: location, mediaURL: "https://\(mediaURL)", lat: latPost, lon: longPost, completion: handlePostResponse(success:error:))
            }
        }
    }
    
    func handlePostResponse(success: Bool, error: Error?) {
        if success {
            print("Post success")
            self.dismiss(animated: true) {
                if let firstViewController = self.navigationController?.viewControllers[1] {
                    self.navigationController?.popToViewController(firstViewController, animated: true)
                }
            }
        } else {
            showPostError()
        }
    }
    
    func handlePutResponse(success: Bool, error: Error?) {
        if success {
                self.dismiss(animated: true) {
                    if let firstVC = self.navigationController?.viewControllers[1] {
                        self.navigationController?.popToViewController(firstVC, animated: true)
                    }
                }
        } else {
            showPostError()
        }
    }
    
    
    func showPostError() {
        let alertVC = UIAlertController(title: "Posting Failure", message: "There was an error posting your location to the servers.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
}
