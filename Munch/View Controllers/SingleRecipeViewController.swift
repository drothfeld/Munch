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
    // UI Elements
    @IBOutlet weak var MenuBarHeaderText: UILabel!
    @IBOutlet weak var DeleteRecipeButton: UIButton!
    @IBOutlet weak var RecipeNameLabel: UILabel!
    @IBOutlet weak var RecipeCategoryLabel: UILabel!
    
    // Defined Values
    var selectedRecipe: Recipe? {
        didSet {
            interfaceSetup()
        }
    }
    var cookingCategory: CookingCategory? {
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
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login_background.png")!)
        if let selectedRecipe = selectedRecipe, let cookingCategory = cookingCategory {
            if let DeleteRecipeButton = DeleteRecipeButton,
            let RecipeNameLabel = RecipeNameLabel,
            let RecipeCategoryLabel = RecipeCategoryLabel {
                RecipeNameLabel.text = selectedRecipe.name
                RecipeCategoryLabel.text = cookingCategory.name.uppercased()
                RecipeCategoryLabel.backgroundColor = cookingCategory.color
            }
        }
    }
    
    // Sending back the cooking category the user was in
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! RecipeCategoryListViewController
        controller.cookingCategory = cookingCategory
    }
    
    // Hides status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
}
