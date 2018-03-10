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
            let userFoodStockRef = Database.database().reference(withPath: "user-food-stock/" + truncatedUserEmail)
            userFoodStockRef.observe(.value, with: { snapshot in
                print(snapshot.value)
            })
            testLabel.text = truncatedUserEmail // TEST
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

