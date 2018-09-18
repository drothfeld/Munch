//
//  ViewController.swift
//  Munch
//
//  Created by Dylan Rothfeld on 3/4/18.
//  Copyright © 2018 Dylan Rothfeld. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController, UITextFieldDelegate {
    // Controller Variables
    var invalidLoginCredentials: Bool = true
    
    // UI Elements
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    
    // Onload
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        interfaceSetup()
    }
    
    // User attempts to log in
    @IBAction func loginButtonPressed(_ sender: Any) {
        Auth.auth().signIn(withEmail: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            // Encountered login error
            if ((error) != nil) {
                self.errorMessageLabel.isHidden = false
                self.errorMessageLabel.text = "Incorrect username/password"
                self.invalidLoginCredentials = true
            // Successful login
            } else {
                self.errorMessageLabel.isHidden = true
                self.invalidLoginCredentials = false
                self.performSegue(withIdentifier: "homeLogin", sender: self)
            }
        }
    }
    
    // User forgot their password
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        //TODO: Button is currently hidden until new user workflow is finalized
    }
    
    // User wants to create a new account
    @IBAction func createNewAccountButtonPressed(_ sender: Any) {
        
    }
    
    // Checks whether segue should be preformed based on login info
    func shouldPerformSegueWithIdentifier(_ identifier: String!, sender: AnyObject!) -> Bool {
        if (self.invalidLoginCredentials) {
            return false
        }
        return true
    }
    
    // Configuring ui elements when app loads
    func interfaceSetup() {
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login_background.png")!)
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        usernameTextField.attributedPlaceholder = NSAttributedString(string:"Username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        loginButton.imageView?.layer.cornerRadius = 10
    }
    
    // Hide keyboard
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // Hides status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }


}

