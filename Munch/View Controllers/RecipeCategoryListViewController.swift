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
    var selectedRecipes: [Recipe] = []
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
                // Getting recipes JSON object
                let recipesRef = Database.database().reference(withPath: "recipes/")
                recipesRef.observe(.value, with: { snapshot in
                    // Parsing JSON data
                    for item in snapshot.children {
                        let recipe = Recipe(snapshot: item as! DataSnapshot)
                        // Making sure recipe is of the correct cooking category
                        if (recipe.type.uppercased() == cookingCategory.name) {
                            self.selectedRecipes.append(recipe)
                        }
                    }
                })
        }
    }
    
    // Hides status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
}
