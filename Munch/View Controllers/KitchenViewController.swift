//
//  KitchenViewController.swift
//  Munch
//
//  Created by Dylan Rothfeld on 3/13/18.
//  Copyright © 2018 Dylan Rothfeld. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class KitchenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // UI Elements
    @IBOutlet weak var KitchenTableView: UITableView!
    @IBOutlet weak var MenuBarView: UIView!
    
    // Defined Values
    var cookingCategoryList: [CookingCategory] = []
    let loopCategoryListMultiplier: Int = 5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interfaceSetup()
        prepare()  
    }
    
    // Refresh the table
    func prepare() {
        refreshTable()
    }
    
    // Setting up interface
    func interfaceSetup() {
        // Removing lines between cells
        self.KitchenTableView.separatorStyle = .none
        self.MenuBarView.center = CGPoint(x: 187.5, y: -25.0)
    }
    
    // Showing and hiding menu bar when user is/isn't scrolling
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if(velocity.y>0) {
            UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.MenuBarView.center = CGPoint(x: 187.5, y: -25.0)
//                print("Hide")
            }, completion: nil)
            
        } else {
            UIView.animate(withDuration: 0.25, delay: 0, options: UIView.AnimationOptions(), animations: {
                self.MenuBarView.center = CGPoint(x: 187.5, y: 25.0)
//                print("Unhide")
            }, completion: nil)
        }
    }
    
    // Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODO: Creating the illusion of looping the tableview items
//        for _ in 1...loopCategoryListMultiplier {
//            for (_, cookingCategory) in cooking_categories.enumerated() {
//                cookingCategoryList.append(cookingCategory)
//            }
//        }
        
        return cooking_categories.count
    }
    
    // Row Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (UIScreen.main.bounds.height / 4)
    }
    
    // Cell Data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Defining cell attribute
        let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath)
        cell.textLabel?.text = "     " + cooking_categories[indexPath.item].name
        cell.backgroundColor = cooking_categories[indexPath.item].color
        cell.textLabel?.font = UIFont(name: "Lato-Bold", size: 20.0)
        cell.detailTextLabel?.text = ""
        cell.imageView?.image = cooking_categories[indexPath.item].icon
        
        // Changing accessory type attributes
        cell.tintColor = UIColor.white
        let image = UIImage(named:"cell-selection-icon.png")?.withRenderingMode(.alwaysTemplate)
        let checkmark  = UIImageView(frame:CGRect(x:0, y:0, width:((image?.size.width)!/25), height:((image?.size.height)!/25)));
        checkmark.image = image
        cell.accessoryView = checkmark
        
        // Manually changing image size
        let itemSize = CGSize.init(width: 100, height: 100)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
        let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
        cell.imageView?.image!.draw(in: imageRect)
        cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
        return cell
    }
    
    // Table Refresh
    func refreshTable() {
        self.KitchenTableView.reloadData()
    }
    
    // Choosing specific cooking category
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = KitchenTableView.indexPathForSelectedRow {
            let cookingCategory: CookingCategory
            cookingCategory = cooking_categories[indexPath.row]
            let controller = segue.destination as! RecipeCategoryListViewController
            controller.cookingCategory = cookingCategory
        }
    }
    
    // Hides status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
}
