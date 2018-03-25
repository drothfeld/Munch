//
//  RecipeCategoryListViewController.swift
//  Munch
//
//  Created by Dylan Rothfeld on 3/23/18.
//  Copyright © 2018 Dylan Rothfeld. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class RecipeCategoryListViewController: UIViewController {
    // UI Elements
    
    // Defined Values
    var selectedRecipes: [Recipe]!
    var cookingCategory: CookingCategory? {
        didSet {
            interfaceSetup()
        }
    }
    
    // Onload
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        interfaceSetup()
    }
    
    // Setting up view
    func interfaceSetup() {
        if let cookingCategory = cookingCategory {
            print(cookingCategory.name)
        }
    }
    
    // Hides status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
}
