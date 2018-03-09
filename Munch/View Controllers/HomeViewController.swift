//
//  HomeViewController.swift
//  Munch
//
//  Created by Dylan Rothfeld on 3/8/18.
//  Copyright © 2018 Dylan Rothfeld. All rights reserved.
//

import Foundation
import FirebaseAuth

class HomeViewController: UIViewController {
    
    // Onload
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        interfaceSetup()
    }
    
    // Configuring ui elements when app loads
    func interfaceSetup() {
    }
    
    // Hides status bar
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    
}

