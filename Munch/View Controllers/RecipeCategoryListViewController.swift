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

class RecipeCategoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // UI Elements
    @IBOutlet weak var MenuBar: UIView!
    @IBOutlet weak var MenuBarCategoryText: UILabel!
    @IBOutlet weak var RecipeTableView: UITableView!
    
    // Defined Values
    var selectedRecipes: [Recipe] = []
    var selectedCateogry: CookingCategory!
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
        prepare()
    }
    
    // Refresh the table
    func prepare() {
        refreshTable()
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
                selectedCateogry = cookingCategory
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
                    self.refreshTable()
                })
        }
    }
    
    // Cell Data
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(selectedRecipes)
        
        // Defining cell attribute
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        cell.backgroundColor = selectedCateogry.color
        cell.textLabel?.font = UIFont(name: "Lato-Bold", size: 20.0)
        cell.detailTextLabel?.text = ""
        cell.textLabel?.text = "     " + selectedRecipes[indexPath.item].name
        
        // Changing accessory type attributes
        cell.tintColor = UIColor.white
        let image = UIImage(named:"cell-selection-icon.png")?.withRenderingMode(.alwaysTemplate)
        let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width:((image?.size.width)!/25), height:((image?.size.height)!/25)));
        checkmark.image = image
        cell.accessoryView = checkmark
        
        return cell
    }
    
    // Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedRecipes.count
    }
    
    // Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UIScreen.main.bounds.height / 8)
    }
    
    // Table Refresh
    func refreshTable() {
        self.RecipeTableView.reloadData()
    }
    
    // Hides status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
}
