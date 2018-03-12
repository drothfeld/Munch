//
//  UserProfile.swift
//  Munch
//
//  Created by Dylan Rothfeld on 3/11/18.
//  Copyright © 2018 Dylan Rothfeld. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct UserProfile {
    // Fields
    var firstname: String
    var lastname: String
    let ref: DatabaseReference?
    
    // Constructors
    init(firstname: String, lastname: String, key: String = "") {
        self.firstname = firstname
        self.lastname = lastname
        self.ref = nil
    }
    
    init(snapshot: DataSnapshot) {
        let snapshotValue = snapshot.value as! [String: AnyObject]
        firstname = snapshotValue["firstname"] as! String
        lastname = snapshotValue["lastname"] as! String
        ref = snapshot.ref
    }
    
    func toAnyObject() -> Any {
        return [
            "firstname": firstname,
            "lastname": lastname,
        ]
    }
}
