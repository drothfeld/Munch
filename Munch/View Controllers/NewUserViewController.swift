//
//  NewUserViewController.swift
//  Munch
//
//  Created by Dylan Rothfeld on 3/6/18.
//  Copyright © 2018 Dylan Rothfeld. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class NewUserViewController: UIViewController, UITextFieldDelegate {
    // Controller Elements
    var invalidLoginCredentials: Bool = true
    
    // UI Elements
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var newUserButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    // Onload
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        interfaceSetup()
    }
    
    // Configuring ui elements when app loads
    func interfaceSetup() {
        // Setting textfield delegates
        passwordTextField.delegate = self
        usernameTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        confirmPasswordTextField.delegate = self
        // Setting placeholder text for textfields
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login_background.png")!)
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        usernameTextField.attributedPlaceholder = NSAttributedString(string:"Username", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        firstNameTextField.attributedPlaceholder = NSAttributedString(string:"First Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        lastNameTextField.attributedPlaceholder = NSAttributedString(string:"Last Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        confirmPasswordTextField.attributedPlaceholder = NSAttributedString(string:"Confirm Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        newUserButton.imageView?.layer.cornerRadius = 10
    }

    // User tries to create new account
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        // Check if a user with the given username already exists
        let database = Database.database().reference()
        database.child("Users").observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            
            // User already exists
//            if snapshot.hasChild(Auth.auth().currentUser!.uid) {
            if (5 < 1) {
                // TODO: IS NOT PROPERLY WORKING
//                self.errorMessageLabel.isHidden = false
//                self.errorMessageLabel.text = "That username is already in use"
//                self.invalidLoginCredentials = true
            }
                
            // Validate create account fields
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
                    // Checking that confirm password matches
                else if (!self.passwordConfirmMatches(password: self.passwordTextField.text!, confirmPassword: self.confirmPasswordTextField.text!)) {
                        self.errorMessageLabel.isHidden = false
                        self.errorMessageLabel.text = "Passwords do not match"
                        self.invalidLoginCredentials = true
                }
                    // Checking profile
                else if (!self.isValidProfile(firstname: self.firstNameTextField.text!, lastname: self.lastNameTextField.text!)) {
                    self.errorMessageLabel.isHidden = false
                    self.errorMessageLabel.text = "Invalid first/last name"
                }
                    // All validation passed, create new account
                else {
                    self.errorMessageLabel.isHidden = true
                    self.invalidLoginCredentials = false
                    Auth.auth().createUser(withEmail: self.usernameTextField.text!, password: self.passwordTextField.text!) {
                        (user, error) in
                        // ...
                    }
                    // Create new JSON user endpoint
                    let profileRef = Database.database().reference(withPath: "user-profile/")
                    let newUserProfile = UserProfile(firstname: self.firstNameTextField.text!, lastname: self.lastNameTextField.text!)
                    let newUserProfileRef = profileRef.child(self.stripDotCom(username: self.usernameTextField.text!))
                    newUserProfileRef.setValue("name")
                    let newProfileNameRef = Database.database().reference(withPath: "user-profile/" + self.stripDotCom(username: self.usernameTextField.text!) + "/name")
                    newProfileNameRef.setValue(newUserProfile.toAnyObject())
                    
                    // If everything went smoothly, take the user back to the login screen
                    self.performSegue(withIdentifier: "backToLogIn", sender: self)
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
        let capitalResult = texttest.evaluate(with: password)
        
        // Check if password contains number
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberResult = texttest1.evaluate(with: password)
        
        // Check if password contains a special character
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialResult = texttest2.evaluate(with: password)
        
        // Check password length
        let minimumRequiredLength = 6
        var countResult = false
        if (password.count < minimumRequiredLength) {
            countResult = false
        } else {
            countResult = true
        }
        
        // All conditions must be met
        return (capitalResult && numberResult && specialResult && countResult)
    }
    
    // Checks if the re-entered confirm password matches the original
    func passwordConfirmMatches(password: String, confirmPassword: String) -> Bool {
        if (password == confirmPassword) {
            return true
        } else {
            return false
        }
    }
    
    // Checks if given profile strings are valid
    func isValidProfile(firstname: String, lastname: String) -> Bool {
        // Checks if first/last names are at least the minimum length
        let minimumRequiredLength = 2
        let firstnameResult: Bool = (firstname.count > minimumRequiredLength)
        let lastnameResult: Bool = (lastname.count > minimumRequiredLength)
        
        // All conditions must be met
        return (firstnameResult && lastnameResult)
    }
    
    // Checks whether segue should be preformed based on login info
    func shouldPerformSegueWithIdentifier(_ identifier: String!, sender: AnyObject!) -> Bool {
        if (self.invalidLoginCredentials) {
            return false
        }
        return true
    }
    
    // Strip the ".com" from a string
    func stripDotCom(username: String) -> String {
        var truncated = username
        for _ in 1...4 {
            truncated.remove(at: truncated.index(before: truncated.endIndex))
        }
        return truncated
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

