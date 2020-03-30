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
        
        let FBloginButton = FBLoginButton(permissions: [ .publicProfile ])
        FBloginButton.delegate = self

        for const in FBloginButton.constraints{
            if const.firstAttribute == NSLayoutConstraint.Attribute.height && const.constant == 28 {
                FBloginButton.removeConstraint(const)
            }
        }
        view.addSubview(FBloginButton)
        FBloginButton.translatesAutoresizingMaskIntoConstraints = false
        FBloginButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        FBloginButton.leadingAnchor.constraint(equalToSystemSpacingAfter: passwordTextfield.leadingAnchor, multiplier: 0).isActive = true
        FBloginButton.trailingAnchor.constraint(equalToSystemSpacingAfter: passwordTextfield.trailingAnchor, multiplier: 0).isActive = true
        FBloginButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        
        if let accessToken = AccessToken.current {
            // User already logged in with FaceBook
            print("User already logged in")
            print(accessToken)
        }
    }
    
    // MARK: - Facebook login delegates
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let result = result else { return }
        print("FB tapped")
        if ((error) != nil) {
            // Process error
            print(error as Any)
        }
        else if result.isCancelled {
            // Handle cancellations
            print("Cancelled")
        }
        else {
            MapClient.Auth.facebookLogin = true
            print("FB LOGIN SUCCESS")
            if let vc = storyboard?.instantiateViewController(withIdentifier: "navVC") {
                present(vc, animated: true)
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("Logged Out")
    }

    override func viewDidAppear(_ animated: Bool) {
        if (AccessToken.current != nil)
        {
            if let vc = storyboard?.instantiateViewController(withIdentifier: "navVC") {
                present(vc, animated: true)
            }
        }
    }



    @IBAction func loginButtonTapped(_ sender: Any) {
        loggingIn(true)
        MapClient.login(username: emailTextfield.text ?? "", password: passwordTextfield.text ?? "", completion: handleLoginResponse(success:error:))
    }
    
    
    func handleLoginResponse(success: Bool, error: Error?) {
        if success {
            print("Login Successful")
            MapClient.getPublicUserInfo { (response, error) in
                print(error?.localizedDescription as Any)
            }
            self.performSegue(withIdentifier: "loginSegue", sender: nil)
            passwordTextfield.text = ""
            loggingIn(false)
        } else {
            let error = error! as NSError
            
            if error.code == -1001 || error.code == -999 {
                self.showErrorAlert(title: "Login Failed", error: error.localizedDescription)
            } else if error.code == 4865 {
                self.showErrorAlert(title: "Login Failed", error: "The Username or Password was incorrect")
            } else if error.code == 4864 {
                self.showErrorAlert(title: "Login Failed", error: "There was a problem trying to connect to the network")
            } else {
                self.showErrorAlert(title: "Login Failed", error: error.localizedDescription)
            }
            loggingIn(false)
        }
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



