//
//  CurrentGameViewController.swift
//  versus
//
//  Created by Brandon Meeks on 11/29/16.
//  Copyright © 2016 meeks. All rights reserved.
//

import UIKit
import Firebase

class CurrentGameViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var dataRef:FIRDatabaseReference!
    var currentGameId:String!
    var currentTurn:Int!
    
    @IBOutlet weak var shooterPicker: UIPickerView!
    @IBOutlet weak var catcherPicker: UIPickerView!
    @IBOutlet weak var outcomePicker: UIPickerView!
    @IBOutlet weak var currentTurnLabel: UILabel!
    
    var shooters = [String]()
    var catchers = ["NOBODY"]
    
    var outcomes = ["TABLE", "PLINK", "PLUNK", "DROP", "PLUNDER"]

    override func viewDidLoad() {
        super.viewDidLoad()
        dataRef = FIRDatabase.database().reference()

    }
    
    override func viewWillAppear(animated: Bool) {
        
        var err = UIAlertController(title: "No User Logged In", message: "You are not logged in. In order to use the Groups and Play tabs, you must log into a valid user profile", preferredStyle: .Alert)
        err.addAction(UIAlertAction(title: "Log In", style: .Cancel, handler: {action in
            self.tabBarController?.selectedIndex = 0
        }))

        if (!Functions.loggedIn()){
            self.presentViewController(err, animated: true, completion: nil)
        }
        else {
            dataRef.child("users/" + Functions.getCurrentUserName() + "/currentGame").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if !snapshot.exists() {
                    self.currentGameId = "NONE"
                    err = UIAlertController(title: "No Active Game", message: "There is currently no active game of die for this user.  Would you like to create one?", preferredStyle: .Alert)
                    err.addAction(UIAlertAction(title: "Create Game", style: .Default, handler: {action in
                        self.tabBarController?.selectedIndex = 1
                    }))
                    err.addAction(UIAlertAction(title: "Not Now", style: .Cancel, handler: {action in
                        self.tabBarController?.selectedIndex = 0
                    }))
                    self.presentViewController(err, animated: true, completion: nil)
                }else{
                    
                    // Initialize values
                    self.currentGameId = snapshot.value!["id"] as! String!
                    self.currentTurn = snapshot.value!["currentTurn"] as! Int!
                    self.currentTurnLabel.text = "Turn " + String(self.currentTurn)
                    
                    // get usernames and add their images to the screen
                    self.dataRef.child("games/" + self.currentGameId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        
                        // initialize current players
                        self.shooters.append(snapshot.value!["player1"] as! String!)
                        self.shooters.append(snapshot.value!["player2"] as! String!)
                        self.shooters.append(snapshot.value!["player3"] as! String!)
                        self.shooters.append(snapshot.value!["player4"] as! String!)
                        
                        // initialize current players
                        self.catchers.append(snapshot.value!["player1"] as! String!)
                        self.catchers.append(snapshot.value!["player2"] as! String!)
                        self.catchers.append(snapshot.value!["player3"] as! String!)
                        self.catchers.append(snapshot.value!["player4"] as! String!)
                        
                        // reload picker to reflect new information
                        self.shooterPicker.reloadAllComponents()
                        self.catcherPicker.reloadAllComponents()
                    })
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        
    }
    
    // Picker View Code Protocol Code
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 3 {    // Differentiate between player picker or outcome picker
            return self.outcomes.count
        }
        if pickerView.tag == 2 {
            return self.catchers.count
        }
        return self.shooters.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 3 {
            return self.outcomes[row]
        }
        if pickerView.tag == 2 {
            return self.catchers[row]
        }
        return self.shooters[row]
    }
    
    // Button Events
    @IBAction func advanceTurn(sender: AnyObject?) {
        let shooter = self.shooters[self.shooterPicker.selectedRowInComponent(0)]
        let catcher = self.catchers[self.catcherPicker.selectedRowInComponent(0)]
        let outcome = self.outcomes[self.outcomePicker.selectedRowInComponent(0)]
        
        let turn = [
            "shooter": shooter,
            "catcher": catcher,
            "outcome": outcome
        ]
        
        
        // Push new turn onto game
        self.dataRef.child("games/" + self.currentGameId + "/turns/" + String(self.currentTurn)).setValue(turn)
        
        // Start new turn
        self.currentTurn = self.currentTurn + 1
        self.currentTurnLabel.text = String(self.currentTurn)
        self.dataRef.child("users/" + Functions.getCurrentUserName() + "/currentGame/currentTurn").setValue(self.currentTurn)
        

        // TODO: Set individual player stats
        switch outcome {
            case "PLUNK":
                self.incrementUserStat(shooter, stat: "PLUNKS")
                break
            case "DROP":
                self.incrementUserStat(catcher, stat: "PLUNKS")
                break
            case "PLINK":
                self.incrementUserStat(shooter, stat: "PLUNKS")
                break
            case "TABLE":
                self.incrementUserStat(shooter, stat: "TABLES")
                if catcher != "NOBODY" {
                    self.incrementUserStat(catcher, stat: "CATCHES")
                }
                break
            default:
                print("defaulted out")
        }
        
        self.incrementUserStat(shooter, stat: "SHOTS")

    }
    
    func incrementUserStat(username: String, stat:String) {
        self.dataRef.child("users/" + username + "/stats/" + stat).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let count = snapshot.value as! Int!
            self.dataRef.child("users/" + username + "/stats/" + stat).setValue(count + 1)
        })
    }
    
    @IBAction func gameOver(sender: AnyObject) {
        self.dataRef.child("users/" + Functions.getCurrentUserName() + "/currentGame").setValue(nil)
        self.advanceTurn(nil)
        Functions.alert("Game Completed!")
        self.viewDidLoad()
    }


}
