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

class NewRecipeFullViewController: UIViewController, UITextFieldDelegate {
    // UI Elements
    @IBOutlet weak var CategorySelectionsView: UIView!
    @IBOutlet weak var RecipeNameTextField: UITextField!
    @IBOutlet weak var SelectCategoryButton: UIButton!
    @IBOutlet weak var DrinkCategoryButton: UIButton!
    @IBOutlet weak var RedMeatCategoryButton: UIButton!
    @IBOutlet weak var SeafoodCategoryButton: UIButton!
    @IBOutlet weak var VegetarianCategoryButton: UIButton!
    @IBOutlet weak var SoupCategoryButton: UIButton!
    @IBOutlet weak var SandwichCategoryButton: UIButton!
    @IBOutlet weak var DessertCategoryButton: UIButton!
    @IBOutlet weak var PoultryCategoryButton: UIButton!
    @IBOutlet weak var BreakfastCategoryButton: UIButton!
    @IBOutlet weak var SelectCategoryIcon: UIImageView!
    @IBOutlet weak var CategoryColorImage: UIImageView!
    @IBOutlet weak var IngredientsView: UIView!
    @IBOutlet weak var InstructionsTextView: UITextView!
    @IBOutlet weak var IngredientsTextView: UITextView!
    @IBOutlet weak var OptionalTextView: UITextView!
    @IBOutlet weak var ServingsTextView: UITextView!
    @IBOutlet weak var ErrorTextLabel: UILabel!
    
    // Controller Values
    var selectedCategory: CookingCategory!
    var categorySelectionIsOn: Bool = false
    
    // Onload
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        interfaceSetup()
        print(CategorySelectionsView.frame.origin)
    }
    
    // Hides status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    // Select category dropdown button is pressed
    @IBAction func selectCategoryButtonPressed(_ sender: Any) {
        if (categorySelectionIsOn) {
            animateCategorySelectionOut()
        } else {
            animateCategorySelectionIn()
        }
    }
    
    // Animate category selection menu
    func animateCategorySelectionIn() {
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            self.CategorySelectionsView.frame.origin = CGPoint(x: -6.0, y: 61.0)
            self.IngredientsView.frame.origin = CGPoint(x: 350.0, y: 61.0)
        })
        categorySelectionIsOn = true
    }
    func animateCategorySelectionOut() {
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            self.CategorySelectionsView.frame.origin = CGPoint(x: -400.0, y: 61.0)
            self.IngredientsView.frame.origin = CGPoint(x: -6.0, y: 61.0)
        })
        categorySelectionIsOn = false
    }
    
    
    // Hide keyboard
    func textFieldShouldReturn(_ scoreText: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    // Set up interface elements
    func interfaceSetup() {
        // Building button array
        let cookingCategoryButtons: [UIButton] = [DrinkCategoryButton, RedMeatCategoryButton, SeafoodCategoryButton, VegetarianCategoryButton, SoupCategoryButton, SandwichCategoryButton, DessertCategoryButton, PoultryCategoryButton, BreakfastCategoryButton]
        // Setting ui element attributes
        for (index, button) in cookingCategoryButtons.enumerated() {
            button.backgroundColor = cooking_categories[index].color
        }
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login_background.png")!)
        self.RecipeNameTextField.delegate = self
        self.RecipeNameTextField.attributedPlaceholder = NSAttributedString(string:"Recipe Name", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
    }
    
    // User presses the create recipe button
    @IBAction func CreateRecipeButtonPressed(_ sender: Any) {
        // Check if all recipe form fields are valid
        if (!allFieldsValid()) {
            ErrorTextLabel.isHidden = false
            ErrorTextLabel.text = "Invalid field entry in recipe form"
        }
        // Get the current logged in user and create new recipe
        else {
            
        }
    }
    
    // Check validity of new recipe form elements
    func allFieldsValid() -> Bool {
        // Validate recipe name
        if (RecipeNameTextField.text == nil || RecipeNameTextField.text == "") {
            return false
        }
        // Validate recipe category
        if (selectedCategory == nil) {
            return false
        }
        // Validate ingredients
        // TODO: Need to validate parsed text to make sure user entered
        // ingredients in the proper format.
        if (IngredientsTextView.text == nil || IngredientsTextView.text == "") {
            return false
        }
        // Validate instructions
        if (InstructionsTextView.text == nil || InstructionsTextView.text == "") {
            return false
        }
        
        // No need to validate optional ingredients/instructions
        
        // Validate servings information
        if (ServingsTextView.text == nil || ServingsTextView.text == "") {
            return false
        }
        
        // If all validations pass, return true
        return true
    }
    
    // Food category button is pressed
    @IBAction func DrinkCategoryButtonPressed(_ sender: Any) {
        selectedCategory = drinks
        SelectCategoryIcon.image = drinks.icon
        SelectCategoryButton.setTitle("Drink", for: .normal)
        CategoryColorImage.backgroundColor = drinks.color
        animateCategorySelectionOut()
    }
    @IBAction func RedMeatCategoryButtonPressed(_ sender: Any) {
        selectedCategory = red_meat
        SelectCategoryIcon.image = red_meat.icon
        SelectCategoryButton.setTitle("Red Meat", for: .normal)
        CategoryColorImage.backgroundColor = red_meat.color
        animateCategorySelectionOut()
    }
    @IBAction func SeafoodCategoryButtonPressed(_ sender: Any) {
        selectedCategory = seafood
        SelectCategoryIcon.image = seafood.icon
        SelectCategoryButton.setTitle("Seafood", for: .normal)
        CategoryColorImage.backgroundColor = seafood.color
        animateCategorySelectionOut()
    }
    @IBAction func VegetarianCategoryButtonPressed(_ sender: Any) {
        selectedCategory = vegetarian
        SelectCategoryIcon.image = vegetarian.icon
        SelectCategoryButton.setTitle("Vegetarian", for: .normal)
        CategoryColorImage.backgroundColor = vegetarian.color
        animateCategorySelectionOut()
    }
    @IBAction func SoupCategoryButtonPressed(_ sender: Any) {
        selectedCategory = soups
        SelectCategoryIcon.image = soups.icon
        SelectCategoryButton.setTitle("Soup", for: .normal)
        CategoryColorImage.backgroundColor = soups.color
        animateCategorySelectionOut()
    }
    @IBAction func SandwichCategoryButtonPressed(_ sender: Any) {
        selectedCategory = sandwiches
        SelectCategoryIcon.image = sandwiches.icon
        SelectCategoryButton.setTitle("Sandwich", for: .normal)
        CategoryColorImage.backgroundColor = sandwiches.color
        animateCategorySelectionOut()
    }
    @IBAction func DessertCategoryButtonPressed(_ sender: Any) {
        selectedCategory = dessert
        SelectCategoryIcon.image = dessert.icon
        SelectCategoryButton.setTitle("Dessert", for: .normal)
        CategoryColorImage.backgroundColor = dessert.color
        animateCategorySelectionOut()
    }
    @IBAction func PoultryCategoryButtonPressed(_ sender: Any) {
        selectedCategory = poultry
        SelectCategoryIcon.image = poultry.icon
        SelectCategoryButton.setTitle("Poultry", for: .normal)
        CategoryColorImage.backgroundColor = poultry.color
        animateCategorySelectionOut()
    }
    @IBAction func BreakfastCategoryButtonPressed(_ sender: Any) {
        selectedCategory = breakfast
        SelectCategoryIcon.image = breakfast.icon
        SelectCategoryButton.setTitle("Breakfast", for: .normal)
        CategoryColorImage.backgroundColor = breakfast.color
        animateCategorySelectionOut()
    }
    
}

