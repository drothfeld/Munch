//
//  CookingCategories.swift
//  Munch
//
//  Created by Dylan Rothfeld on 3/13/18.
//  Copyright © 2018 Dylan Rothfeld. All rights reserved.
//

import UIKit

// Default set cooking categories
let drinks = CookingCategory(name: "DRINKS", color: UIColor(red: 243/255, green: 187/255, blue: 114/255, alpha: 1.0), icon: #imageLiteral(resourceName: "drinks-icon.png"))
let red_meat = CookingCategory(name: "RED MEAT", color: UIColor(red: 255/255, green: 133/255, blue: 167/255, alpha: 1.0), icon: #imageLiteral(resourceName: "red-meat-icon.png"))
let seafood = CookingCategory(name: "SEAFOOD", color: UIColor(red: 123/255, green: 236/255, blue: 236/255, alpha: 1.0), icon: #imageLiteral(resourceName: "seafood-icon.png"))
let vegetarian = CookingCategory(name: "VEGETARIAN", color: UIColor(red: 180/255, green: 221/255, blue: 115/255, alpha: 1.0), icon: #imageLiteral(resourceName: "vegetarian-icon.png"))
let soups = CookingCategory(name: "SOUPS", color: UIColor(red: 157/255, green: 179/255, blue: 240/255, alpha: 1.0), icon: #imageLiteral(resourceName: "soups-icon.png"))
let sandwiches = CookingCategory(name: "SANDWICHES", color: UIColor(red: 190/255, green: 132/255, blue: 214/255, alpha: 1.0), icon: #imageLiteral(resourceName: "sandwhiches-icon.png"))
let dessert = CookingCategory(name: "DESSERT", color: UIColor(red: 118/255, green: 220/255, blue: 165/255, alpha: 1.0), icon: #imageLiteral(resourceName: "dessert-icon.png"))
let poultry = CookingCategory(name: "POULTRY", color: UIColor.gray, icon: #imageLiteral(resourceName: "poultry-icon.png"))
let breakfast = CookingCategory(name: "BREAKFAST", color: UIColor.gray, icon: #imageLiteral(resourceName: "breakfast-icon.png"))

let cooking_categories: [CookingCategory] = [drinks, red_meat, seafood, vegetarian, soups, sandwiches, dessert, poultry, breakfast]
