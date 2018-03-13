//
//  CookingCategory.swift
//  Munch
//
//  Created by Dylan Rothfeld on 3/13/18.
//  Copyright © 2018 Dylan Rothfeld. All rights reserved.
//

import UIKit

struct CookingCategory {
    // Fields
    var name: String
    var color: UIColor
    var icon: UIImage
    
    // Constructor
    init(name: String, color: UIColor, icon: UIImage) {
        self.name = name
        self.color = color
        self.icon = icon
    }
}
