//
//  InformationPostingViewController.swift
//  On The Map
//
//  Created by Sean Williams on 07/08/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import UIKit

class InformationPostingViewController: UIViewController {

    @IBOutlet var locationTextfield: UITextField!
    @IBOutlet var linkTextfield: UITextField!
    @IBOutlet var findLocationButton: UIButton!
    @IBOutlet var cancelButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        findLocationButton.layer.cornerRadius = 20.0
        

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func cancelButtonTapped(_ sender: Any) {
    }
    
}
