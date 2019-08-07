//
//  LoginViewController.swift
//  On The Map
//
//  Created by Sean Williams on 06/08/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var loginButton: UIButton!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.center = self.view.center
        loginButton.layer.cornerRadius = 20.0
        
        let attributedString = NSMutableAttributedString(string: "Don't have an account? Sign Up")
        let url = "https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signup&sa=D&ust=1565099137593000"
        attributedString.addAttribute(.link, value: url, range: NSRange(location: 23, length: 7))
        textView.attributedText = attributedString
        textView.textAlignment = .center
        
        
        
        
    }

    @IBAction func loginButtonTapped(_ sender: Any) {
//        MapClient.getStudentLocations { (studentLocations, error) in
//        }
    }
    
}

