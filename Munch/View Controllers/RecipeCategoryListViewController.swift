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

class RecipeCategoryListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // UI Elements
    @IBOutlet weak var MenuBar: UIView!
    @IBOutlet weak var MenuBarCategoryText: UILabel!
    @IBOutlet weak var RecipeTableView: UITableView!
    @IBOutlet weak var NoRecipesLabel: UILabel!
    @IBOutlet weak var CreateNewRecipeBackupButton: UIButton!
    @IBOutlet weak var BackToKitchenButton: UIButton!
    @IBOutlet weak var MenuSearchBar: UISearchBar!
    
    // Defined Values
    var selectedRecipes: [Recipe] = []
    var sortedSelectedRecipes: [Recipe] = []
    var filteredSelectedRecipes: [Recipe] = []
    var isSearching = false
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
        searchBarSetup()
    }
    
    // Refresh the table
    func prepare() {
        refreshTable()
    }
    
    // Search Bar Setup
    func searchBarSetup() {
        MenuSearchBar.delegate = self
        MenuSearchBar.returnKeyType = UIReturnKeyType.done
    }
    
    // Hide keyboard activated from search bar
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.MenuSearchBar.endEditing(true)
    }
    
    // Sort list of recipes alphabetically by name
    func sortRecipesAlphabetically(unsortedList: Array<Recipe>) -> Array<Recipe> {
        return unsortedList.sorted { $0.name < $1.name }
    }
    
    // Search Bar Functionality
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if (MenuSearchBar.text == nil || MenuSearchBar.text == "") {
            isSearching = false
            view.endEditing(true)
        } else {
            isSearching = true
            filteredSelectedRecipes = sortedSelectedRecipes.filter( {$0.name.lowercased().contains(MenuSearchBar.text!.lowercased())} )
        }
        RecipeTableView.reloadData()
    }
    
    // Showing and hiding menu bar when user is/isn't scrolling
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y>0) {
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.MenuBar.center = CGPoint(x: 187.5, y: -28.0)
                //                print("Hide")
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.MenuBar.center = CGPoint(x: 187.5, y: 28.0)
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
                    let MenuBar = MenuBar,
                    let MenuSearchBar = MenuSearchBar {
                    MenuBarCategoryText.text = cookingCategory.name
                    MenuBar.center = CGPoint(x: 187.5, y: -28.0)
                    let searchBarTextField = MenuSearchBar.value(forKey: "searchField") as? UITextField
                    searchBarTextField?.textColor = UIColor.white
                }
                // Getting recipes JSON object
                let recipesRef = Database.database().reference(withPath: "recipes/")
                recipesRef.observe(.value, with: { snapshot in
                    // Parsing JSON data
                    // NOTE: For some reason this is returning two of every item
                    for item in snapshot.children {
                        let recipe = Recipe(snapshot: item as! DataSnapshot)
                        // Making sure recipe is of the correct cooking category
                        if (recipe.type.uppercased() == cookingCategory.name && !self.containsRecipe(recipe: recipe)) {
                            self.selectedRecipes.append(recipe)
                        }
                    }
                    // Checking if there are no available recipes
                    if (self.selectedRecipes.count == 0) {
                        self.NoRecipesLabel.isHidden = false
                        self.CreateNewRecipeBackupButton.isHidden = false
                        self.RecipeTableView.isHidden = true
                        self.BackToKitchenButton.isHidden = false
                        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "login_background.png")!)
                    }
                    // Reset table
                    self.refreshTable()
                })
        }
    }
    
    // Checks if a given recipe exists in the selectedRecipe array
    func containsRecipe(recipe: Recipe) -> Bool {
        for (index, _) in (selectedRecipes.enumerated()) {
            if (selectedRecipes[index].name == recipe.name &&
                selectedRecipes[index].author == recipe.author &&
                selectedRecipes[index].ingredients == recipe.ingredients &&
                selectedRecipes[index].instructions == recipe.instructions &&
                selectedRecipes[index].optional == recipe.optional &&
                selectedRecipes[index].servingSize == recipe.servingSize) {
                    return true
            }
        }
        return false
    }
    
    // Cell Data
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(selectedRecipes)
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)

        if (isSearching) {
            // Defining cell attribute
            cell.backgroundColor = selectedCateogry.color
            cell.textLabel?.font = UIFont(name: "Lato-Bold", size: 20.0)
            cell.detailTextLabel?.text = ""
            cell.textLabel?.text = "     " + filteredSelectedRecipes[indexPath.item].name
            
            // Changing accessory type attributes
            cell.tintColor = UIColor.white
            let image = UIImage(named:"cell-selection-icon.png")?.withRenderingMode(.alwaysTemplate)
            let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width:((image?.size.width)!/25), height:((image?.size.height)!/25)));
            checkmark.image = image
            cell.accessoryView = checkmark
            
        } else {
            // Defining cell attribute
            cell.backgroundColor = selectedCateogry.color
            cell.textLabel?.font = UIFont(name: "Lato-Bold", size: 20.0)
            cell.detailTextLabel?.text = ""
            cell.textLabel?.text = "     " + sortedSelectedRecipes[indexPath.item].name
            
            // Changing accessory type attributes
            cell.tintColor = UIColor.white
            let image = UIImage(named:"cell-selection-icon.png")?.withRenderingMode(.alwaysTemplate)
            let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width:((image?.size.width)!/25), height:((image?.size.height)!/25)));
            checkmark.image = image
            cell.accessoryView = checkmark
        }
        
        return cell
    }
    
    // Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (isSearching) {
            return filteredSelectedRecipes.count
        }
        return selectedRecipes.count
    }
    
    // Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UIScreen.main.bounds.height / 8)
    }
    
    // Table Refresh
    func refreshTable() {
        sortedSelectedRecipes = sortRecipesAlphabetically(unsortedList: selectedRecipes)
        self.RecipeTableView.reloadData()
    }
    
    // Hides status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
}
