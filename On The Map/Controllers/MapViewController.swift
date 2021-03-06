//
//  MapViewController.swift
//  On The Map
//
//  Created by Sean Williams on 07/08/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import UIKit
import MapKit
import FBSDKLoginKit


class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var refreshButton: UIBarButtonItem!
    @IBOutlet var mapView: MKMapView!
    
    var annotations = [MKPointAnnotation]()

    override func viewWillAppear(_ animated: Bool) {
        loadMapAnnotations()
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    func loadMapAnnotations() {
        mapView.removeAnnotations(annotations)
        annotations = []
      
        MapClient.getStudentLocations { (response, error) in
            if error != nil {
                self.showErrorAlert(title: "Download Failed", error: "There was a problem trying to get student locations from the server. Please try refreshing the page.")
                return
            }
            
            StudentModel.studentLocationData = response
            let locations = StudentModel.studentLocationData
            for student in locations {
                let lat = CLLocationDegrees(student.latitude)
                let long = CLLocationDegrees(student.longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let first = student.firstName
                let last = student.lastName
                let mediaURL = student.mediaURL
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(first) \(last)"
                annotation.subtitle = mediaURL
                
                // Place the annotation in an array of annotations.
                self.annotations.append(annotation)
            }
            
            DispatchQueue.main.async {
                // When the array is complete, we add the annotations to the map.
                self.mapView.addAnnotations(self.annotations)
                
                for student in StudentModel.studentLocationData {
                    if student.uniqueKey == MapClient.Auth.uniqueKey {
                        let lat = CLLocationDegrees(student.latitude)
                        let long = CLLocationDegrees(student.longitude)
                        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                        
                        let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500000, longitudinalMeters: 500000)
                        self.mapView.setRegion(viewRegion, animated: true)
                        self.mapView.showsUserLocation = true
                        break
                    }
                }

            }
        }
        
        
    }

    
    // MARK: - MKMapViewDelegate
    
    // Create a view with a right callout accessory view.
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .blue
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. Opens the system browser to the URL specified in the annotationViews subtitle property.
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                if let url = URL(string: toOpen) {
                    app.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        MapClient.getStudentLocations { (students, error) in
            StudentModel.studentLocationData = students
            DispatchQueue.main.async {
                self.loadMapAnnotations()
            }
        }
    }
    
    
    @IBAction func pinButtonTapped(_ sender: Any) {
        
        for student in StudentModel.studentLocationData {
            if student.uniqueKey == MapClient.Auth.uniqueKey {
                // show alert
                    MapClient.Auth.updatingLocation = true
                    MapClient.Auth.objectID = student.objectId
                
                    let vc = UIAlertController(title: "Existing Location Found", message: "Would you like to update your exisiting location?", preferredStyle: .alert)
                    vc.addAction(UIAlertAction(title: "Overwrite", style: .default, handler: { (segue) in
                        self.performSegue(withIdentifier: "mapPin", sender: segue)
                    }))
                    vc.addAction(UIAlertAction(title: "Cancel", style: .default))
                    self.present(vc, animated: true)
                return
                
            } else {
                MapClient.Auth.updatingLocation = false
                performSegue(withIdentifier: "mapPin", sender: nil)
            }
        }
    }
 
    @IBAction func logoutTapped(_ sender: Any) {
        
        if MapClient.Auth.facebookLogin == true {
            // Logout of facebook
            LoginManager().logOut()
            MapClient.Auth.facebookLogin = false
        } else {
            MapClient.logout {}
        }
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
