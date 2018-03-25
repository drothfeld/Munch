//
//  Recipe.swift
//  Munch
//
//  Created by Dylan Rothfeld on 3/25/18.
//  Copyright © 2018 Dylan Rothfeld. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Recipe {
    // Fields
    var name: String
    var isQuickSnapShot: String
    var type: String
    var ingredients: String
    var instructions: String
    var optional: String
    var servingSize: String
    let ref: DatabaseReference?
    
    // Constructors
    init(name: String, isQuickSnapShot: String, type: String, ingredients: String, instructions: String, optional: String, servingSize: String, key: String = "") {
        self.name = name
        self.isQuickSnapShot = isQuickSnapShot
        self.type = type
        self.ingredients = ingredients
        self.instructions = instructions
        self.optional = optional
        self.servingSize = servingSize
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        isQuickSnapShot = snapshotValue["isQuickSnapShot"] as! String
        type = snapshotValue["type"] as! String
        ingredients = snapshotValue["ingredients"] as! String
        instructions = snapshotValue["instructions"] as! String
        optional = snapshotValue["optional"] as! String
        servingSize = snapshotValue["servingSize"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "name": name,
            "isQuickSnapShot": isQuickSnapShot,
            "type": type,
            "ingredients": ingredients,
            "instructions": instructions,
            "optional": optional,
            "servingSize": servingSize
        ]
    }
}


