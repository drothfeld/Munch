//
//  NewUserViewController.swift
//  Munch
//
//  Created by Dylan Rothfeld on 3/6/18.
//  Copyright © 2018 Dylan Rothfeld. All rights reserved.
//

import Foundation
import FirebaseAuth

class NewUserViewController: UIViewController {
    // UI Elements
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var newUserButton: UIButton!
    @IBOutlet weak var errorMessageLabel: UIButton!
    
    // Onload
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        interfaceSetup()
    }
    
    // Configuring ui elements when app loads
    func interfaceSetup() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login_background.png")!)
        passwordTextField.attributedPlaceholder = NSAttributedString(string:"Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        usernameTextField.attributedPlaceholder = NSAttributedString(string:"Username", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        newUserButton.imageView?.layer.cornerRadius = 10
    }
    
    // Hides status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
}

