//
//  FoodItem.swift
//  Munch
//
//  Created by Dylan Rothfeld on 3/10/18.
//  Copyright © 2018 Dylan Rothfeld. All rights reserved.
//

import UIKit

class FoodItem {
    // Fields
    var inStock: Bool
    var name: String
    var type: String
    
    // Constructor
    init(inStock: Bool, name: String, type: String) {
        self.inStock = inStock
        self.name = name
        self.type = type
    }
}

