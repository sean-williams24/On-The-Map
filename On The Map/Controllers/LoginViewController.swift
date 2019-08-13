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
    @IBOutlet var activityView: UIActivityIndicatorView!
    
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
        loggingIn(true)
        MapClient.login(username: emailTextfield.text ?? "", password: passwordTextfield.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            print("Login Successful")
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            passwordTextfield.text = ""
        } else {
            self.loginErrorAlert(error: error?.localizedDescription ?? "")
            loggingIn(false)
        }
    }

    func loginErrorAlert(error: String) {
        let ac = UIAlertController(title: "Login Failed", message: error, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        show(ac, sender: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    func loggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityView.startAnimating()
        } else {
            activityView.stopAnimating()
        }
        emailTextfield.isEnabled = !loggingIn
        passwordTextfield.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
}

