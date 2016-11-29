//
//  NewGameViewController.swift
//  versus
//
//  Created by Brandon Meeks on 11/28/16.
//  Copyright © 2016 meeks. All rights reserved.
//

import UIKit
import Firebase

class NewGameViewController: UIViewController, UserPickedDelegate {
    
    var dataRef:FIRDatabaseReference!
    var groupId:String!
    var members = Set<String>()
    
    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var player2Label: UILabel!
    @IBOutlet weak var player3Label: UILabel!
    @IBOutlet weak var player4Label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataRef = FIRDatabase.database().reference()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userWasPicked(username: String, player: String) {
        if player == "PLAYER1" {
            player1Label.text = username
            members.insert(username)
        }
        else if player == "PLAYER2" {
            player2Label.text = username
            members.insert(username)
        }
        else if player == "PLAYER3" {
            player3Label.text = username
            members.insert(username)
        }
        else if player == "PLAYER4" {
            player4Label.text = username
            members.insert(username)
        }
    }
    
    @IBAction func createNewGame(sender: AnyObject) {
        if self.members.count == 4 {
            
            let newGame = self.dataRef.child("groups/" + self.groupId + "games").childByAutoId()
            let newGameKey = newGame.key
            
            self.dataRef.child("groups/" + self.groupId + "/games/" + newGameKey + "/player1").setValue(player1Label.text)
            self.dataRef.child("groups/" + self.groupId + "/games/" + newGameKey + "/player2").setValue(player2Label.text)
            self.dataRef.child("groups/" + self.groupId + "/games/" + newGameKey + "/player3").setValue(player3Label.text)
            self.dataRef.child("groups/" + self.groupId + "/games/" + newGameKey + "/player4").setValue(player4Label.text)

            self.navigationController?.popViewControllerAnimated(true)
            
        }
        else{
             Functions.alert("There must be 4 players in a game!")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "findUserSegue" {
            
            let destination = segue.destinationViewController as! FindUserViewController
            destination.delegate = self
            destination.groupId = self.groupId
            destination.currentMembers = self.members
            destination.currentPlayer = sender?.currentTitle
            
        }
    }

}
