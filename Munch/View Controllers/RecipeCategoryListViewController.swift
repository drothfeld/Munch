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
    @IBOutlet weak var MenuBar: UIView!
    @IBOutlet weak var MenuBarCategoryText: UILabel!
    
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
    
    // Showing and hiding menu bar when user is/isn't scrolling
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y>0) {
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.MenuBar.center = CGPoint(x: 187.5, y: -25.0)
                //                print("Hide")
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.MenuBar.center = CGPoint(x: 187.5, y: 25.0)
                //                print("Unhide")
            }, completion: nil)
        }
    }
    
    // Setting up view
    func interfaceSetup() {
        if let cookingCategory = cookingCategory{
                // Setting menu bar text header
                if let MenuBarCategoryText = MenuBarCategoryText,
                    let MenuBar = MenuBar {
                    MenuBarCategoryText.text = cookingCategory.name
                    MenuBar.center = CGPoint(x: 187.5, y: -25.0)
                }
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
