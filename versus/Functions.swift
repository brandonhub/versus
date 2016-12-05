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
    
    
    static func getLeaderboardPlunks(groupId:String, callback: ([(String, Int)]) -> Void){
        var usersAndPlunks = [(String, Int)]()
        
        var dataRef = FIRDatabase.database().reference()
        
        dataRef.child("groups/" + groupId + "/members").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            for child in snapshot.children {
                let username = child.key!
                dataRef.child("users/" + username + "/stats/" + "PLUNKS").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    let count = snapshot.value as! Int
                    usersAndPlunks.append(username,count)
                    usersAndPlunks.sort { $0.1 < $1.1}
                    print(usersAndPlunks)
                    callback(usersAndPlunks)
                    
                })
                
            }
            
            
            
        }) { (error) in
            print(error.localizedDescription)
            
        }
    
    
    }
    /*
    
    static func getLeaderboardCatches(groupId:String) -> ([(String, Double)]){
        var usersAndCatches = [String, Double]()
        plunks = [Int]()
        
        var catches = 0
        var drops = 0
        users.removeAll()
        self.dataRef = FIRDatabase.database().reference()
        
        dataRef.child("groups/" + groupId + "/members").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            for child in snapshot.children {
                let username = child.key!
                self.dataRef.child("users/" + username + "/stats/" + "CATCHES").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    catches = snapshot.value as! Int
                    
                })
                self.dataRef.child("users/" + username + "/stats/" + "DROPS").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    drops = snapshot.value as! Int
                    
                })
                
                usersAndCatches.append(username,Double(catches)/Double(catches+drops))
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
            
        }
        usersAndCatches!.sort { $0.1 < $1.1}
        return usersAndCatches
    }
    
    static func getLeaderboardPER(groupId:String) -> ([(String, Double)]){
        var usersAndPER = [String, Double]()
        
        
        var plunks = 0
        var drops = 0
        var games = 0
        
        users.removeAll()
        self.dataRef = FIRDatabase.database().reference()
        
        dataRef.child("groups/" + groupId + "/members").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            for child in snapshot.children {
                let username = child.key!
                self.dataRef.child("users/" + username + "/stats/" + "PLUNKS").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    plunks = snapshot.value as! Int
                    
                })
                self.dataRef.child("users/" + username + "/stats/" + "GAMES").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    games = snapshot.value as! Int
                    
                })
                self.dataRef.child("users/" + username + "/stats/" + "DROPS").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    drops = snapshot.value as! Int
                    
                })
                
                usersAndPER.append(username,Double(plunks - drops)/Double(games))
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
            
        }
        usersAndPER!.sort { $0.1 < $1.1}
        return usersAndPER
    }
 */
    
}

