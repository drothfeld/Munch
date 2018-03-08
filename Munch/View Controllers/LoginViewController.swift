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
        // If the user does exist, procede to home page
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
                self.errorMessageLabel.isHidden = false
                self.errorMessageLabel.text = "That username is already in use"
            }
                
            // Validate username and password fields
            else {
                // Checking username
                if (!self.isValidEmail(username: self.usernameTextField.text!)) {
                    self.errorMessageLabel.isHidden = false
                    self.errorMessageLabel.text = "Invalid username/email"
                }
                // Checking password
                else if (!self.isValidPassword(password: self.passwordTextField.text!)) {
                    self.errorMessageLabel.isHidden = false
                    self.errorMessageLabel.text = "Password must contain: uppercase, special char, number"
                }
                // All validation passed, create new account
                else {
                    Auth.auth().createUser(withEmail: self.usernameTextField.text!, password: self.passwordTextField.text!) {
                        (user, error) in
                        // ...
                    }
                }
            }
        })
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

