//
//  Functions.swift
//  sway
//
//  Created by Brandon Meeks on 10/4/16.
//  Copyright © 2016 meeks. All rights reserved.
//

import Foundation
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import UIKit

class Functions {
    
    static func getCurrentUser() -> FIRUser?{
        return FIRAuth.auth()?.currentUser
    }
    
    static func getCurrentUserName() -> String {
        let displayName = (FIRAuth.auth()?.currentUser!.displayName!)! as String
        let firstNameLastName = displayName.componentsSeparatedByString(" ")
        let username = firstNameLastName[0] + firstNameLastName[1]
        return username
    }
    
    static func getCurrentUnixTimestamp() -> Double {
        let timestamp = NSDate().timeIntervalSince1970
        return timestamp
    }
    
    static func alert(message: String) {
        let alertView = UIAlertView()
        alertView.addButtonWithTitle("Ok")
        alertView.message = message
        alertView.show()
    }
    
    static func assignImage(imageView:UIImageView, imageUrl:String) {
            print("changing image...")
            let url = NSURL(string: imageUrl)
            let data = NSData(contentsOfURL: url!)
            imageView.image = UIImage(data: data!)
    }
}
