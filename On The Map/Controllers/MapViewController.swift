//
//  MapViewController.swift
//  On The Map
//
//  Created by Sean Williams on 07/08/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet var refreshButton: UIBarButtonItem!
    @IBOutlet var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        
        MapClient.getStudentLocations { (response, error) in
            if error != nil {
                // present alert controller showing error //
                return
            }
            StudentModel.studentLocationData = response
            
            var annotations = [MKPointAnnotation]()
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
                
                // Finally we place the annotation in an array of annotations.
                annotations.append(annotation)
            }
            
            DispatchQueue.main.async {
                // When the array is complete, we add the annotations to the map.
                self.mapView.addAnnotations(annotations)
                
                let firstViewPin = StudentModel.studentLocationData[0]
                let lat = CLLocationDegrees(firstViewPin.latitude)
                let long = CLLocationDegrees(firstViewPin.longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 500000, longitudinalMeters: 500000)
                self.mapView.setRegion(viewRegion, animated: true)
                self.mapView.showsUserLocation = true
            }
        }
    }
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    

    
    // MARK: - MKMapViewDelegate
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:], completionHandler: nil)
            }
        }
    }
    
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        MapClient.getStudentLocations { (students, error) in
            StudentModel.studentLocationData = students
            DispatchQueue.main.async {
//                self.loadMapAnnoations()
            }
        }
    }
    
    
    
 
}
