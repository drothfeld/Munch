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
    
    // Defined Values
    var cookingCategoryList: [CookingCategory] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        interfaceSetup()
        prepare()
    }
    
    func prepare() {
        refreshTable()
    }
    
    // Setting up interface
    func interfaceSetup() {
        // Removing lines between cells
        self.KitchenTableView.separatorStyle = .none
    }
    
    // Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let indexPath = KitchenTableView.indexPathForSelectedRow {
//            let cookingCategory: CookingCategory
//            cookingCategory = cooking_categories[indexPath.row]
//            let controller = segue.destination as! CookingCategoryRecipesViewController
//            controller.currentCategory = cookingCategory
//        }
//    }
    
    // Hides status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
}
