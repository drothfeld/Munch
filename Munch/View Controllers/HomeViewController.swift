//
//  HomeViewController.swift
//  Munch
//
//  Created by Dylan Rothfeld on 3/8/18.
//  Copyright © 2018 Dylan Rothfeld. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {
    // Controller Elements
    var truncatedUserEmail: String!
    var foodItems: [FoodItem] = []
    
    // UI Elements
    @IBOutlet weak var testLabel: UILabel!
    
    // Onload
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        interfaceSetup()
    }
    
    // Configuring ui elements when app loads
    func interfaceSetup() {
        
        // Getting info of the currently logged in user
        let user = Auth.auth().currentUser
        if let user = user {
            truncatedUserEmail = stripDotCom(username: user.email!)
            
            // Getting user-food-stock JSON object
            let userFoodStockRef = Database.database().reference(withPath: "user-food-stock/" + truncatedUserEmail)
            userFoodStockRef.observe(.value, with: { snapshot in
                //print(snapshot.value)
                // Parsing JSON data
                for item in snapshot.children {
                    let foodItem = FoodItem(snapshot: item as! DataSnapshot)
                    self.foodItems.append(foodItem)
                }
                self.testLabel.text = self.foodItems[1].name
            })
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
    
    // Hides status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
}

