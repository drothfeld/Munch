//
//  SingleRecipeViewController.swift
//  Munch
//
//  Created by Dylan Rothfeld on 4/13/18.
//  Copyright © 2018 Dylan Rothfeld. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class SingleRecipeViewController: UIViewController {
    // Defined Values
    var selectedRecipe: Recipe? {
        didSet {
            interfaceSetup()
        }
    }
    
    // Onload
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //interfaceSetup()
    }
    
    // Setting up view
    func interfaceSetup() {
        if let selectedRecipe = selectedRecipe {
        }
    }
    
    // Hides status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
}
