//
//  LoginViewController.swift
//  On The Map
//
//  Created by Sean Williams on 06/08/2019.
//  Copyright © 2019 Sean Williams. All rights reserved.
//

import UIKit
import FacebookLogin
import FBSDKLoginKit
import FacebookCore


class LoginViewController: UIViewController, UITextViewDelegate, LoginButtonDelegate {
    

    @IBOutlet var loginButton: UIButton!
    @IBOutlet var emailTextfield: UITextField!
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var textView: UITextView!
    @IBOutlet var activityView: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.center = self.view.center
        loginButton.layer.cornerRadius = 20.0
        LoginManager().logOut()
        
        let attributedString = NSMutableAttributedString(string: "Don't have an account? Sign Up")
        let url = "https://www.google.com/url?q=https://www.udacity.com/account/auth%23!/signup&sa=D&ust=1565099137593000"
        attributedString.addAttribute(.link, value: url, range: NSRange(location: 23, length: 7))
        textView.attributedText = attributedString
        textView.textAlignment = .center
        
        // Facebook login button
        
        let loginButton = FBLoginButton(permissions: [ .publicProfile ])
        loginButton.center.x = self.view.center.x
        loginButton.frame.origin.y = self.view.frame.height - (loginButton.frame.height * 3)
        loginButton.delegate = self
        view.addSubview(loginButton)
        
        if let accessToken = AccessToken.current {
            // User already logged in with FaceBook
            print("User already logged in")
            print(accessToken)
        }
    }
    
    // MARK: - Facebook login delegates
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let result = result else { return }
        
        if ((error) != nil) {
            // Process error
            print(error as Any)
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            MapClient.Auth.facebookLogin = true
            print("FB LOGIN SUCCESS")
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logged Out")
    }

    override func viewDidAppear(_ animated: Bool) {
        if (AccessToken.current != nil && MapClient.Auth.facebookLogin == true)
        {
            performSegue(withIdentifier: "loginSegue", sender: self)
        }
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
            loggingIn(false)
        } else {
            let error = error! as NSError
            
            if error.code == -1001 || error.code == -999 {
                self.loginErrorAlert(error: error.localizedDescription)
            } else if error.code == 4865 {
                self.loginErrorAlert(error: "The Username or Password was incorrect")
            } else if error.code == 4864 {
                self.loginErrorAlert(error: "There was a problem trying to connect to the network")
            } else {
                self.loginErrorAlert(error: error.localizedDescription)
            }
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
            loginButton.alpha = 0.2

        } else {
            activityView.stopAnimating()
            loginButton.alpha = 1.0

        }
        emailTextfield.isEnabled = !loggingIn
        passwordTextfield.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
}



