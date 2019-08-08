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
    
    let firstName = "Jack"
    let lastName = "Bauer"

    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        finishButton.layer.cornerRadius = 20.0
        
        
        let address = location
        CLGeocoder().geocodeAddressString(address, completionHandler: { placemarks, error in
            if (error != nil) {
                return
            }
            
            if let placemark = placemarks?[0]  {
                let longitude = String(format: "%.04f", (placemark.location?.coordinate.longitude ?? 0.0)!)
                let latitude = String(format: "%.04f", (placemark.location?.coordinate.latitude ?? 0.0)!)
                let name = placemark.name!
                let country = placemark.country!
                let region = placemark.administrativeArea!
                
                let long = CLLocationDegrees(longitude) ?? 0
                let lat = CLLocationDegrees(latitude) ?? 0
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = "\(self.firstName) \(self.lastName): \(name) - \(region) / \(country)"
                annotation.subtitle = self.mediaURL
                
                self.mapView.addAnnotation(annotation)
                
                let viewRegion = MKCoordinateRegion(center: coordinate, latitudinalMeters: 600, longitudinalMeters: 600)
                self.mapView.setRegion(viewRegion, animated: true)
                self.mapView.showsUserLocation = true
                
            }
        })
        
        
    }


    @IBAction func finishButtonTapped(_ sender: Any) {
        
        
    }
}
