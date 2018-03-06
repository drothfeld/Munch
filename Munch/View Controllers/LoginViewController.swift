//
//  ViewController.swift
//  Munch
//
//  Created by Dylan Rothfeld on 3/4/18.
//  Copyright © 2018 Dylan Rothfeld. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    // UI Elements
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UIButton!
    
    // Onload
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        interfaceSetup()
    }
    
    // User attempts to log in
    @IBAction func loginButtonPressed(_ sender: Any) {
        // Check if the user exists
        
        // If the user doesn't exist, check new account requirements and create new user
//        Auth.auth().createUser(withEmail: usernameTextField.text!, password: passwordTextField.text!) {
//            (user, error) in
//            // ...
//        }
        
        // If the user does exist, procede to home page
    }
    
    // Configuring ui elements when app loads
    func interfaceSetup() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login_background.png")!)
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        usernameTextField.attributedPlaceholder = NSAttributedString(string:"Username", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        loginButton.imageView?.layer.cornerRadius = 10
    }
    
    // Hides status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }


}

