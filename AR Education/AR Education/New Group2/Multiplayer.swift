//
//  Multiplayer.swift
//  AR Education
//
//  Created by Paran Sonthalia on 3/11/18.
//  Copyright © 2018 Mango Apps. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class Multiplayer: UIViewController {
    override func viewDidLoad() {
        
        
        writeToFirebase(pushData: ["asdf":"asdf"])
//        ref.child("users").child("a").setValue(["username": "username"])
    }
    
    @objc func writeToFirebase(pushData:NSDictionary) {
        let ref = Database.database().reference()
        ref.updateChildValues(pushData as! [AnyHashable : Any]) { (error, _) in
            if let error = error {
                assertionFailure(error.localizedDescription)
            }
        }
    }
}
