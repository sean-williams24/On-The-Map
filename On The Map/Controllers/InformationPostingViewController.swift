//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Sean Williams on 07/08/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import UIKit
import MapKit

class InformationPostingViewController: UIViewController {

    @IBOutlet var locationTextfield: UITextField!
    @IBOutlet var linkTextfield: UITextField!
    @IBOutlet var findLocationButton: UIButton!
    @IBOutlet var cancelButton: UIBarButtonItem!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var longitude = 0.0
    var latitude = 0.0
    var name = ""
    var region = ""
    var country = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findLocationButton.layer.cornerRadius = 20.0
        

    }
    
    @IBAction func findLocationButtonTapped(_ sender: Any) {
        self.setLoading(true)
        
        guard let address = locationTextfield.text else { return }
        CLGeocoder().geocodeAddressString(address, completionHandler: { placemarks, error in
           
            if error != nil {
                self.setLoading(false)
                DispatchQueue.main.async {
                    self.showGeocodeFailure(message: "Problem finding location. Please try again.")
                }
            }
            
            if let placemark = placemarks?[0]  {
                let longitude = String(format: "%.04f", (placemark.location?.coordinate.longitude ?? 0.0)!)
                let latitude = String(format: "%.04f", (placemark.location?.coordinate.latitude ?? 0.0)!)
                self.name = placemark.name!
                self.country = placemark.country!
                self.region = placemark.administrativeArea ?? ""
                self.longitude = Double(longitude) ?? 0.0
                self.latitude = Double(latitude) ?? 0.0
                
                self.performSegue(withIdentifier: "newLocation", sender: nil)
                self.setLoading(false)

            }
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "newLocation" {
            let vc = segue.destination as! NewLocationMapViewController
            
            vc.longPost = longitude
            vc.latPost = latitude
            vc.location = locationTextfield.text!
            if linkTextfield.text == "" {
                vc.mediaURL = "udacity.com"
            } else {
                vc.mediaURL = linkTextfield.text!
            }
            vc.name = name
            vc.country = country
            vc.region = region
        }
 
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func setLoading(_ loading: Bool) {
        if loading {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        locationTextfield.isEnabled = !loading
        linkTextfield.isEnabled = !loading
        findLocationButton.isEnabled = !loading
    }
    
    func showGeocodeFailure(message: String) {
        let alertVC = UIAlertController(title: "Unknown Location", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true)
    }
    
    
    // MARK - Hide/show Keyboard
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
}


