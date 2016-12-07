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
    
    static func loggedIn() -> Bool {
        if FIRAuth.auth()?.currentUser != nil {
            return true
        }
        return false
    }
    
    static func signOutUser() {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
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
    
    
    static func getLeaderboardPlunks(groupId:String , callback: ([(String, Int)]) -> Void){
        var usersAndPlunks = [(String, Int)]()
        
        var dataRef = FIRDatabase.database().reference()
        
        dataRef.child("groups/" + groupId + "/members").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            for child in snapshot.children {
                let username = child.key!
                dataRef.child("users/" + username + "/stats/" + "PLUNKS").observeSingleEventOfType(.Value, withBlock: { (nextUser) in
                    let count = nextUser.value as! Int
                    usersAndPlunks.append(username,count)
                    //print(usersAndPlunks)
                    if (usersAndPlunks.count == Int(snapshot.childrenCount)){
                        usersAndPlunks.sortInPlace { $0.1 > $1.1}
                        callback(usersAndPlunks)
                    }
                    
                    
                })
                
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
            
        }
        
        
    }
    
    static func getLeaderboardCatchPercentage(groupId:String , callback: ([(String, Int)]) -> Void){
        var usersAndCatches = [(String, Int)]()
        
        var catchesarr:[Int] = []
        var dropsarr:[Int] = []
        var users:[String] = []
        
        var dataRef = FIRDatabase.database().reference()
        dataRef.child("groups/" + groupId + "/memberCount").observeSingleEventOfType(.Value, withBlock: { (memberCount) in
            let count =  memberCount.value as! Int
            dataRef.child("groups/" + groupId + "/members").observeSingleEventOfType(.Value, withBlock: { (members) in
                for child in members.children {
                    
                    let username = child.key!
                    users.append(username)
                    
                    dataRef.child("users/" + username + "/stats/" + "CATCHES").observeSingleEventOfType(.Value, withBlock: { (catches) in
                        catchesarr.append(catches.value as! Int)
                        
                        dataRef.child("users/" + username + "/stats/" + "DROPS").observeSingleEventOfType(.Value, withBlock: { (drops) in
                            dropsarr.append(drops.value as! Int)
                            
                            var percentage = 0
                            if(count == dropsarr.count){
                                
                                for i in 0..<dropsarr.count {
                                    
                                    var catches = catchesarr[i]
                                    var drops = dropsarr[i]
                                    var user = users[i]
                                    var percentage = 0
                                    if (catches + drops != 0){
                                        
                                        percentage = 100 * catches / (catches + drops)
                                    }
                                    
                                    usersAndCatches.append((user, percentage))
                                    
                                }
                                
                                print(usersAndCatches)
                                if (usersAndCatches.count == count){
                                    usersAndCatches.sortInPlace { $0.1 > $1.1}
                                    callback(usersAndCatches)
                                }
                                
                            }
                            
                        })
                        
                    })
                    
                    
                }
                
            })
            
        }) { (error) in
            print(error.localizedDescription)
            
        }
        
        
    }
    
    static func makeTeams(user1ID:String, user2ID:String,user3ID:String,user4ID:String, callback: ([String]) -> Void) {
        let dataRef = FIRDatabase.database().reference()
        // Get Player 1 Stats
        dataRef.child("users/" + user1ID + "/stats/").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let user1Drops = snapshot.value!["DROPS"] as! Int
            let user1Plunks = snapshot.value!["PLUNKS"] as! Int
            let user1Games = snapshot.value!["GAMES"] as! Int
            var per1 = 0.0;
            if(user1Games != 0){
                per1 = Double(user1Plunks-user1Drops)/Double(user1Games)
            }
            print(user1ID, per1)
            // Get Player 2 Stats
            dataRef.child("users/" + user2ID + "/stats/").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                let user2Drops = snapshot.value!["DROPS"] as! Int
                let user2Plunks = snapshot.value!["PLUNKS"] as! Int
                let user2Games = snapshot.value!["GAMES"] as! Int
                var per2 = 0.0;
                if(user2Games != 0){
                    per2 = Double(user2Plunks-user2Drops)/Double(user2Games)
                }
                print(user2ID, per2)
                // Get Player 3 Stats
                dataRef.child("users/" + user3ID + "/stats/").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    let user3Drops = snapshot.value!["DROPS"] as! Int
                    let user3Plunks = snapshot.value!["PLUNKS"] as! Int
                    let user3Games = snapshot.value!["GAMES"] as! Int
                    var per3 = 0.0;
                    if(user3Games != 0){
                        per3 = Double(user3Plunks-user3Drops)/Double(user3Games)
                    }
                    print(user3ID, per3)
                    // Get Player 4 Stats
                    dataRef.child("users/" + user4ID + "/stats/").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        let user4Drops = snapshot.value!["DROPS"] as! Int
                        let user4Plunks = snapshot.value!["PLUNKS"] as! Int
                        let user4Games = snapshot.value!["GAMES"] as! Int
                        var per4 = 0.0;
                        if(user4Games != 0){
                            per4 = Double(user4Plunks-user4Drops)/Double(user4Games)
                        }
                        print(user4ID, per4)
                        
                        // Analysis
                        var order = [String]();
                        var pers = [per1,per2,per3,per4];
                        print(pers);
                        pers = pers.sort();
                        print(pers)
                        var user1Set = false, user2Set = false,user3Set = false,user4Set = false;
                        for(var i = 0;i<=3;i = i+1){
                            if(pers[i] == per1 && user1Set == false){
                                order.append(user1ID);
                                user1Set = true;
                            }
                            else if(pers[i] == per2 && user2Set == false){
                                order.append(user2ID);
                                user2Set = true;
                            }
                            else if(pers[i] == per3 && user3Set == false){
                                order.append(user3ID);
                                user3Set = true;
                            }
                            else if(pers[i] == per4 && user4Set == false){
                                order.append(user4ID);
                                user4Set = true;
                            }
                        }
                        swap(&order[1], &order[3]) // rearrange array for proper teams
                        // print(order) // Returned in rank 1, 4, 3, 2
                        // Team 1 is (1,4) Team 2 is (3,2)
                        callback(order)
                    })
                })

            })
        })
        
    }
    
    
    static func getLeaderboardPER(groupId:String , callback: ([(String, Int)]) -> Void){
        var usersAndPer = [(String, Int)]()
        
        
        var plunksarr:[Int] = []
        var dropsarr:[Int] = []
        var gamesarr:[Int] = []
        var users:[String] = []
        
        var per = 0
        
        var dataRef = FIRDatabase.database().reference()
        
        dataRef.child("groups/" + groupId + "/members").observeSingleEventOfType(.Value, withBlock: { (members) in
            let count = Int(members.childrenCount)
            for child in members.children {
                let username = child.key!
                users.append(username)
                dataRef.child("users/" + username + "/stats/" + "PLUNKS").observeSingleEventOfType(.Value, withBlock: { (userPlunks) in
                    plunksarr.append(userPlunks.value as! Int)
                    dataRef.child("users/" + username + "/stats/" + "DROPS").observeSingleEventOfType(.Value, withBlock: { (userDrops) in
                        dropsarr.append(userDrops.value as! Int)
                        
                        dataRef.child("users/" + username + "/stats/" + "GAMES").observeSingleEventOfType(.Value, withBlock: { (userGames) in
                            gamesarr.append(userGames.value as! Int)
                            
                            if (gamesarr.count == plunksarr.count){
                                for i in 0..<plunksarr.count {
                                    print(i)
                                    var plunks = plunksarr[i]
                                    var drops = dropsarr[i]
                                    var games = gamesarr[i]
                                    var user = users[i]
                                    if(games==0){
                                        per = 0;
                                    }
                                    else{
                                    per = (100 * (plunks) - (drops)) / (games)
                                    }
                                    usersAndPer.append((user,per))
                                }
                                print(usersAndPer)
                                if (usersAndPer.count == count){
                                    usersAndPer.sortInPlace { $0.1 > $1.1}
                                    callback(usersAndPer)
                                }
                                
                            }
                            
                            
                        })
                        
                    })
                    
                })
                
            }
            
            
            
        }) { (error) in
            print(error.localizedDescription)
            
        }
        
        
    }
    
    static func getLine(username1:String, username2:String, username3:String, username4:String , callback: [Double] -> Void){
        var returnArray:[Double] = []
        var noZeroes = true
        
        var dataRef = FIRDatabase.database().reference()
        dataRef.child("users/" + username1 + "/stats/").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            var p1totalDrops = snapshot.value!["DROPS"] as! Int
            var p1totalCatches = snapshot.value!["CATCHES"] as! Int
            
            var p1totalPlunks = snapshot.value!["PLUNKS"] as! Int
            var p1totalNormal = snapshot.value!["TABLES"] as! Int
            var p1totalShots = snapshot.value!["SHOTS"] as! Int
            dataRef.child("users/" + username2 + "/stats/").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                
                
                var p2totalDrops = snapshot.value!["DROPS"] as! Int
                var p2totalCatches = snapshot.value!["CATCHES"] as! Int
                
                var p2totalPlunks = snapshot.value!["PLUNKS"] as! Int
                var p2totalNormal = snapshot.value!["TABLES"] as! Int
                var p2totalShots = snapshot.value!["SHOTS"] as! Int
                
                dataRef.child("users/" + username3 + "/stats/").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    
                    
                    var p3totalDrops = snapshot.value!["DROPS"] as! Int
                    var p3totalCatches = snapshot.value!["CATCHES"] as! Int
                    
                    var p3totalPlunks = snapshot.value!["PLUNKS"] as! Int
                    var p3totalNormal = snapshot.value!["TABLES"] as! Int
                    var p3totalShots = snapshot.value!["SHOTS"] as! Int
                    dataRef.child("users/" + username4 + "/stats/").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        
                        var p4totalDrops = snapshot.value!["DROPS"] as! Int
                        var p4totalCatches = snapshot.value!["CATCHES"] as! Int
                        
                        var p4totalPlunks = snapshot.value!["PLUNKS"] as! Int
                        var p4totalNormal = snapshot.value!["TABLES"] as! Int
                        var p4totalShots = snapshot.value!["SHOTS"] as! Int
                        
                        
                        var score1 = 0.0
                        var score2 = 0.0
                        
                        if p1totalDrops == 0 {
                            noZeroes = false
                        }
                        if p1totalCatches == 0 {
                            noZeroes = false
                        }
                        
                        if p1totalPlunks == 0 {
                            noZeroes = false
                        }
                        if p1totalNormal == 0 {
                            noZeroes = false
                        }
                        if p1totalShots == 0{
                            noZeroes = false
                        }
                        
                        
                        if p2totalDrops == 0 {
                            noZeroes = false
                        }
                        if p2totalCatches == 0 {
                            noZeroes = false
                        }
                        
                        if p2totalPlunks == 0 {
                            noZeroes = false
                        }
                        if p2totalNormal == 0 {
                            noZeroes = false
                        }
                        if p2totalShots == 0{
                            noZeroes = false
                        }
                        
                        
                        if p3totalDrops == 0 {
                            noZeroes = false
                        }
                        if p3totalCatches == 0 {
                            noZeroes = false
                        }
                        
                        if p3totalPlunks == 0 {
                            noZeroes = false
                        }
                        if p3totalNormal == 0 {
                            noZeroes = false
                        }
                        if p3totalShots == 0{
                            noZeroes = false
                        }
                        
                        if p4totalDrops == 0 {
                            noZeroes = false
                        }
                        if p4totalCatches == 0 {
                            noZeroes = false
                        }
                        
                        if p4totalPlunks == 0 {
                            noZeroes = false
                        }
                        if p4totalNormal == 0 {
                            noZeroes = false
                        }
                        if p4totalShots == 0{
                            noZeroes = false
                        }
                        
                        if (noZeroes){
                        var p1PlunkPercentage = Double(p1totalPlunks)/Double(p1totalShots)
                        var p1TablePercentage = Double(p1totalNormal) / Double(p1totalNormal)
                        var p1DropPercentage =  Double(p1totalDrops)/Double((p1totalDrops + p1totalCatches))
                        
                        var p2PlunkPercentage = Double(p2totalPlunks)/Double(p2totalShots)
                        var p2TablePercentage = Double(p2totalNormal) / Double(p2totalNormal)
                        var p2DropPercentage =  Double(p2totalDrops)/Double((p2totalDrops + p2totalCatches))
                        
                        
                        var p3PlunkPercentage = Double(p3totalPlunks)/Double(p3totalShots)
                        var p3TablePercentage = Double(p3totalNormal) / Double(p3totalNormal)
                        var p3DropPercentage =  Double(p3totalDrops)/Double((p3totalDrops + p3totalCatches))
                        
                        
                        var p4PlunkPercentage = Double(p4totalPlunks)/Double(p4totalShots)
                        var p4TablePercentage = Double(p4totalNormal) / Double(p4totalNormal)
                        var p4DropPercentage =  Double(p4totalDrops)/Double((p4totalDrops + p4totalCatches))
                        
                        
                        
                        var score1 = 0.0
                        var score2 = 0.0
                        
                        
                        var gameover = false
                        while (!gameover){
                            
                            (score2 >= 5 && score2 > score1 + 2 && (score2 % 2) == 1)
                            
                            score1 += p1PlunkPercentage + p1TablePercentage * p3DropPercentage
                            if (score1 >= 5) {
                                returnArray = [0.0, score1 - score2]
                                gameover = true;
                                callback(returnArray)
                                print(returnArray)
                                continue
                                
                                
                            }
                            
                            score2 += p3PlunkPercentage + p3TablePercentage * p1DropPercentage
                            if (score2 >= 5) {
                                returnArray = [1.0, score2 - score1]
                                gameover = true;
                                callback(returnArray)
                                print(returnArray)
                                continue
                                
                                
                            }
                            
                            score1 += p2PlunkPercentage + p2TablePercentage * p4DropPercentage
                            if (score1 >= 5) {
                                returnArray = [0.0, score1 - score2]
                                gameover = true;
                                callback(returnArray)
                                print(returnArray)
                                continue
                                
                                
                            }
                            
                            score2 += p4PlunkPercentage + p4TablePercentage * p2DropPercentage
                            if (score2 >= 5) {
                                returnArray = [1.0, score2 - score1]
                                gameover = true;
                                callback(returnArray)
                                print(returnArray)
                                continue
                                
                                
                            }
                            
                            
                            
                        }
                        }
                        else {
                            //not enough stats
                            returnArray.append(-1.0)
                            callback(returnArray)
                            print(returnArray)
                        }

                    })
                })
            })
        })
    }
    
    
    
    
    
}

