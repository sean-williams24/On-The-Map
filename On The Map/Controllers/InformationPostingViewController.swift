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
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findLocationButton.layer.cornerRadius = 20.0
        

    }
    
    @IBAction func findLocationButtonTapped(_ sender: Any) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! NewLocationMapViewController
        
        // ***** use if or guard lets to show alert if theres an invalid input?
        vc.location = locationTextfield.text!
        vc.mediaURL = linkTextfield.text!
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
}
