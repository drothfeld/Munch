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

class LoginViewController: UIViewController {
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
        //TODO: If the user does exist, continue to home page
    }
    
    // User forgot their password
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        //TODO: Button is currently hidden until new user workflow is finalized
    }
    
    // User wants to create a new account
    @IBAction func createNewAccountButtonPressed(_ sender: Any) {
        // Check if a user with the given username already exists
        let database = Database.database().reference()
        database.child("Users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            print(snapshot)
            
            // User already exists
            if snapshot.hasChild(Auth.auth().currentUser!.uid) {
                // TODO: IS NOT PROPERLY WORKING
                self.errorMessageLabel.isHidden = false
                self.errorMessageLabel.text = "That username is already in use"
                self.invalidLoginCredentials = true
            }
            
            // Validate username and password fields
            else {
                // Checking username
                if (!self.isValidEmail(username: self.usernameTextField.text!)) {
                    self.errorMessageLabel.isHidden = false
                    self.errorMessageLabel.text = "Invalid username/email"
                    self.invalidLoginCredentials = true
                }
                // Checking password
                else if (!self.isValidPassword(password: self.passwordTextField.text!)) {
                    self.errorMessageLabel.isHidden = false
                    self.errorMessageLabel.text = "Invalid password"
                    self.invalidLoginCredentials = true
                }
                // All validation passed, create new account
                else {
                    self.errorMessageLabel.isHidden = true
                    self.invalidLoginCredentials = false
                    Auth.auth().createUser(withEmail: self.usernameTextField.text!, password: self.passwordTextField.text!) {
                        (user, error) in
                        // ...
                    }
                    self.performSegue(withIdentifier: "homeLogin", sender: self)
                }
            }
        })
    }
    
    // Checks whether segue should be preformed based on login info
    func shouldPerformSegueWithIdentifier(_ identifier: String!, sender: AnyObject!) -> Bool {
        NSLog("test")
        if (self.invalidLoginCredentials) {
            return false
        }
        return true
    }
    
    // Checks if a given string is a valid email address
    func isValidEmail(username: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: username)
    }
    
    // Checks if a given string is a valid password
    func isValidPassword(password: String) -> Bool {
        // Check if password contains uppercase letter
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: password)
        
        // Check if password contains number
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: password)
        
        // Check if password contains a special character
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialresult = texttest2.evaluate(with: password)
        
        // All conditions must be met
        return (capitalresult && numberresult && specialresult)
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

