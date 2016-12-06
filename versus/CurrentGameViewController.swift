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
    var currentGroupId:String!
    var currentTurn:Int!
    
    var player1:String!
    var player2:String!
    var player3:String!
    var player4:String!
    
    @IBOutlet weak var shooterPicker: UIPickerView!
    @IBOutlet weak var catcherPicker: UIPickerView!
    @IBOutlet weak var outcomePicker: UIPickerView!
    @IBOutlet weak var currentTurnLabel: UILabel!
    
    
    @IBOutlet weak var player1Image: UIImageView!
    @IBOutlet weak var player2Image: UIImageView!
    @IBOutlet weak var player3Image: UIImageView!
    @IBOutlet weak var player4Image: UIImageView!
    
    @IBOutlet weak var team1ScoreLabel: UILabel!
    @IBOutlet weak var team2ScoreLabel: UILabel!
    
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
                    self.currentGroupId = snapshot.value!["groupId"] as! String!
                    self.currentTurn = snapshot.value!["currentTurn"] as! Int!
                    self.currentTurnLabel.text = "Turn " + String(self.currentTurn)
                    
                    // get usernames and add their images to the screen
                    self.dataRef.child("games/" + self.currentGameId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                        
                        //initialize players
                        self.player1 = snapshot.value!["player1"] as! String!
                        self.player2 = snapshot.value!["player2"] as! String!
                        self.player3 = snapshot.value!["player3"] as! String!
                        self.player4 = snapshot.value!["player4"] as! String!
                        
                        // initialize current shooters
                        self.shooters.append(self.player1)
                        self.shooters.append(self.player2)
                        self.shooters.append(self.player3)
                        self.shooters.append(self.player4)
                        
                        // initialize current cathers
                        self.catchers.append(self.player1)
                        self.catchers.append(self.player2)
                        self.catchers.append(self.player3)
                        self.catchers.append(self.player4)
                        
                        self.addPlayerImages() // add images to screen
                        self.updateScoreLabels()
                        
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
        
        // TODO: Set individual player stats
        switch outcome {
            case "PLUNK":
                self.incrementScore(shooter)
                self.incrementUserStat(shooter, stat: "PLUNKS")
                break
            case "DROP":
                self.incrementScore(shooter)
                self.incrementUserStat(catcher, stat: "DROPS")
                break
            case "PLINK":
                self.incrementUserStat(shooter, stat: "PLINKS")
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
        
        // Start new turn if not game over
        if (sender != nil) {
            self.currentTurn = self.currentTurn + 1
            self.currentTurnLabel.text = String(self.currentTurn)
            self.dataRef.child("users/" + Functions.getCurrentUserName() + "/currentGame/currentTurn").setValue(self.currentTurn)
            
            Functions.alert("Turn saved!")
        }
        else{
            // increment wins and games counts
            let team1Points = Int(team1ScoreLabel.text!)
            let team2Points = Int(team2ScoreLabel.text!)
            
            if team1Points > team2Points {
                self.incrementUserStat(self.player1, stat: "WINS")
                self.incrementUserStat(self.player2, stat: "WINS")
            }
            else if team1Points < team2Points {
                self.incrementUserStat(self.player3, stat: "WINS")
                self.incrementUserStat(self.player4, stat: "WINS")
            }
            
            self.incrementUserStat(self.player1, stat: "GAMES")
            self.incrementUserStat(self.player2, stat: "GAMES")
            self.incrementUserStat(self.player3, stat: "GAMES")
            self.incrementUserStat(self.player4, stat: "GAMES")
        }
    }
    
    func incrementUserStat(username: String, stat:String) {
        self.dataRef.child("users/" + username + "/stats/" + stat).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let count = snapshot.value as! Int!
            self.dataRef.child("users/" + username + "/stats/" + stat).setValue(count + 1)
            
        })
        
        self.dataRef.child("games/" + self.currentGameId + "/" + username + "/" + stat).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let count = snapshot.value as! Int!
            self.dataRef.child("games/" + self.currentGameId + "/" + username + "/" + stat).setValue(count + 1)
        })
    }
    
    func incrementScore(username:String) {
        self.dataRef.child("games/" + self.currentGameId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if username == snapshot.value!["player1"] as! String! || username == snapshot.value!["player2"] as! String!{
                let team1Points = snapshot.value!["team1Points"] as! Int!
                self.dataRef.child("games/" + self.currentGameId + "/team1Points").setValue(team1Points + 1)
            }
            else{
                let team2Points = snapshot.value!["team2Points"] as! Int!
                self.dataRef.child("games/" + self.currentGameId + "/team2Points").setValue(team2Points + 1)
            }
            self.updateScoreLabels()
        })
    }
    
    
    func updateScoreLabels() {
        self.dataRef.child("games/" + self.currentGameId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let team1Points = snapshot.value!["team1Points"] as! Int!
            let team2Points = snapshot.value!["team2Points"] as! Int!
            self.team1ScoreLabel.text = String(team1Points)
            self.team2ScoreLabel.text = String(team2Points)
        })
    }
    
    func addPlayerImages() {

                self.updatePlayerImage(self.player1, image: self.player1Image)
                self.updatePlayerImage(self.player2, image: self.player2Image)
                self.updatePlayerImage(self.player3, image: self.player3Image)
                self.updatePlayerImage(self.player4, image: self.player4Image)
    }
    
    func updatePlayerImage(username:String, image:UIImageView){
        dataRef.child("users/" + username + "/photoUrl").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if !snapshot.exists() { return }
            let urlString = snapshot.value as! String
            print(urlString)
            Functions.assignImage(image, imageUrl: urlString)
        }) { (error) in
            print(error.localizedDescription)
        }
    }

    
    @IBAction func cancelGame(sender: AnyObject) {
         self.dataRef.child("users/" + Functions.getCurrentUserName() + "/currentGame").setValue(nil)
        
        self.dataRef.child("games/" + self.currentGameId).setValue(nil)
        
        var alert = UIAlertController(title: "Game Canceled", message: "If you wish to start annother game, head to the groups tab.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Done", style: .Cancel, handler: {action in
            self.tabBarController?.selectedIndex = 0
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "gameOverSegue" {
            
            self.dataRef.child("users/" + Functions.getCurrentUserName() + "/currentGame").setValue(nil)
            
            // add game to also participating platers
            self.dataRef.child("users/" + self.player1 + "/games/" + self.currentGameId).setValue(true)
            self.dataRef.child("users/" + self.player2 + "/games/" + self.currentGameId).setValue(true)
            self.dataRef.child("users/" + self.player3 + "/games/" + self.currentGameId).setValue(true)
            self.dataRef.child("users/" + self.player4 + "/games/" + self.currentGameId).setValue(true)
            
            // add game to group
            self.dataRef.child("groups/" + self.currentGroupId + "/games/" + self.currentGameId).setValue(true)
            
            // save final turn
            self.advanceTurn(nil)
            
            let destination = segue.destinationViewController as! GameOverViewController
            destination.currentGameId = self.currentGameId
            
            
        }
        
    }


}
