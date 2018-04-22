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
import AVFoundation

class SingleRecipeViewController: UIViewController {
    // UI Elements
    @IBOutlet weak var MenuBarHeaderText: UILabel!
    @IBOutlet weak var DeleteRecipeButton: UIButton!
    @IBOutlet weak var RecipeNameLabel: UILabel!
    @IBOutlet weak var RecipeCategoryLabel: UILabel!
    @IBOutlet weak var DeleteMenuView: UIView!
    @IBOutlet weak var FadeScreenOverlay: UIImageView!
    @IBOutlet weak var SuccessImage: UIImageView!
    @IBOutlet weak var DeleteWarningMessage: UILabel!
    @IBOutlet weak var YesDeleteButton: UIButton!
    @IBOutlet weak var CancelDeleteButton: UIButton!
    @IBOutlet weak var RecipeWasDeletedMessage: UILabel!
    @IBOutlet weak var RecipeIngredientsView: UIView!
    
    // Defined Values
    var truncatedUserEmail: String!
    var isDeleteMenuVisible: Bool = false
    var transitionTimer: Timer = Timer()
    var ingredientList: [(name: String, amount: String, inStock: String)] = []
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
                
                // Assigning static values
                RecipeNameLabel.text = selectedRecipe.name
                RecipeCategoryLabel.text = cookingCategory.name.uppercased()
                RecipeCategoryLabel.backgroundColor = cookingCategory.color
                
                // Getting info of the currently logged in user
                let user = Auth.auth().currentUser
                if let user = user {
                    
                    // Checking if the current user is the creator of the recipe
                    truncatedUserEmail = stripDotCom(username: user.email!)
                    if (selectedRecipe.author == truncatedUserEmail) {
                        DeleteRecipeButton.isHidden = false
                    }
                    
                    // Setting up ingredient tuple array
                    let rawIngredientsText: String = selectedRecipe.ingredients
                    let splitIngredients = rawIngredientsText.components(separatedBy: ",")
                    // Main loop to go through each ingredient
                    for (ingredientIndex, ingredient) in (splitIngredients.enumerated()) {
                        var ingredientText: String = ingredient
                        // Drop the extra space for non-first ingredients
                        if (ingredientIndex != 0) {
                            ingredientText = String(ingredient.dropFirst())
                        }
                        let splitIngredientText = ingredientText.components(separatedBy: ":")
                        for (ingredientPart, ingredientPartText) in (splitIngredientText.enumerated()) {
                            // Handle the ingredient name
                            // TODO: Need to grab users food-stock from database and check if they have ingredient
                            if (ingredientPart == 0) {
                                // Creating ingredient row view
                                let row = UIView(frame: CGRect(x: 0, y: 36*ingredientIndex, width: 310, height: 30))
                                row.backgroundColor = UIColor.black
                                RecipeIngredientsView.addSubview(row)
                                // Creating ingredient text in row
                                //let ingredientName = UILabel(frame: CGRect(x: <#T##Int#>, y: <#T##Int#>, width: <#T##Int#>, height: <#T##Int#>))
                                
                            }
                            // Handle the ingredient amount
                            else if (ingredientPart == 1) {
                            }
                        }
                    }
                }
            }
        }
    }
    
    // Strip the ".com" from a string
    func stripDotCom(username: String) -> String {
        var truncated = username
        for _ in 1...4 {
            truncated.remove(at: truncated.index(before: truncated.endIndex))
        }
        return truncated
    }
    
    // Sending back the cooking category the user was in
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! RecipeCategoryListViewController
        controller.cookingCategory = cookingCategory
    }
    
    // Creator of a recipe presses the delete recipe button
    @IBAction func deleteRecipeButtonPressed(_ sender: Any) {
        // If user was already at the delete menu, then hide it
        if (isDeleteMenuVisible) {
            isDeleteMenuVisible = false
            FadeScreenOverlay.isHidden = true
            DeleteMenuView.isHidden = true
            
        } else {
            isDeleteMenuVisible = true
            FadeScreenOverlay.isHidden = false
            DeleteMenuView.isHidden = false
        }
    }
    
    // User confirms they want to delete the recipe
    @IBAction func deleteRecipe(_ sender: Any) {
        // Unwrap optional and extract recipe API endpoint
        if let selectedRecipe = selectedRecipe {
            var recipeEndpoint: String = ""
            let characters = Array(selectedRecipe.name.lowercased())
            for char in characters {
                if (char == " ") {
                    recipeEndpoint = recipeEndpoint + "-"
                } else {
                    recipeEndpoint = recipeEndpoint + String(char)
                }
            }
            // Deleting database entry
            let recipeRef = Database.database().reference(withPath: "recipes/" + recipeEndpoint)
            recipeRef.removeValue()
        }
        
        // Show success image and play delete sound/image
        startTransitionTimer()
        DeleteWarningMessage.isHidden = true
        RecipeWasDeletedMessage.isHidden = false
        YesDeleteButton.isHidden = true
        CancelDeleteButton.isHidden = true
        SuccessImage.isHidden = false
        AudioServicesPlaySystemSound(SystemSoundID(1116))
    }
    
    // User cancels deleting a recipe
    @IBAction func cancelDeleteRecipe(_ sender: Any) {
        isDeleteMenuVisible = false
        FadeScreenOverlay.isHidden = true
        DeleteMenuView.isHidden = true
    }
    
    // Starts transition timer
    func startTransitionTimer() {
        transitionTimer = Timer.scheduledTimer(timeInterval: 1.5, target: self, selector: (#selector(SingleRecipeViewController.transitionView)), userInfo: nil, repeats: false)
    }
    
    // Leave view after success animation plays
    @objc func transitionView() {
        self.performSegue(withIdentifier: "backToCategory", sender: self)
    }
    
    // Hides status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
}
