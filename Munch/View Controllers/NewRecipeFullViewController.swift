//
//  NewRecipeFullViewController.swift
//  Munch
//
//  Created by Dylan Rothfeld on 3/27/18.
//  Copyright © 2018 Dylan Rothfeld. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class NewRecipeFullViewController: UIViewController {
    
    // Onload
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        interfaceSetup()
    }
    
    // Hides status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    // Set up interface elements
    func interfaceSetup() {
        // Setting background image
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login_background.png")!)
    }
    
}

