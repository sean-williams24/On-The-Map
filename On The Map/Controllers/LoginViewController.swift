//
//  LoginViewController.swift
//  On The Map
//
//  Created by Sean Williams on 06/08/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var loginButton: UIButton!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var signUpLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.center = self.view.center
        loginButton.layer.cornerRadius = 20.0
        
    }


}

