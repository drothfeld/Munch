//
//  FoodItem.swift
//  Munch
//
//  Created by Dylan Rothfeld on 3/10/18.
//  Copyright © 2018 Dylan Rothfeld. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct FoodItem {
    // Fields
    var inStock: String
    var name: String
    var type: String
    let ref: DatabaseReference?
    
    // Constructors
    init(inStock: String, name: String, type: String, key: String = "") {
        self.inStock = inStock
        self.name = name
        self.type = type
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        inStock = snapshotValue["inStock"] as! String
        name = snapshotValue["name"] as! String
        type = snapshotValue["type"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "inStock": inStock,
            "name": name,
            "type": type
        ]
    }
}

