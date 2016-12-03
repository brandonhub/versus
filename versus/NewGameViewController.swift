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
    
    // Outlets
    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var player2Label: UILabel!
    @IBOutlet weak var player3Label: UILabel!
    @IBOutlet weak var player4Label: UILabel!

    @IBOutlet weak var player1Image: UIImageView!
    @IBOutlet weak var player3Image: UIImageView!
    @IBOutlet weak var player2Image: UIImageView!
    @IBOutlet weak var player4Image: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataRef = FIRDatabase.database().reference()
        
        // Round images
        self.player1Image.layer.cornerRadius = self.player1Image.frame.size.width/2
        self.player1Image.clipsToBounds = true;
        
        self.player2Image.layer.cornerRadius = self.player2Image.frame.size.width/2
        self.player2Image.clipsToBounds = true;
        
        self.player3Image.layer.cornerRadius = self.player3Image.frame.size.width/2
        self.player3Image.clipsToBounds = true;
        
        self.player4Image.layer.cornerRadius = self.player4Image.frame.size.width/2
        self.player4Image.clipsToBounds = true;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func userWasPicked(username: String, player: String) {
        
        if player == "PLAYER1" {
            player1Label.text = username
            members.insert(username)
            updatePlayerImage(username, image: player1Image)
        }
        else if player == "PLAYER2" {
            player2Label.text = username
            members.insert(username)
            updatePlayerImage(username, image: player2Image)
        }
        else if player == "PLAYER3" {
            player3Label.text = username
            members.insert(username)
            updatePlayerImage(username, image: player3Image)
        }
        else if player == "PLAYER4" {
            player4Label.text = username
            members.insert(username)
            updatePlayerImage(username, image: player4Image)
        }
    }
    
    @IBAction func createNewGame(sender: AnyObject) {
        if self.members.count == 4 {
            
            let newGame = self.dataRef.child("groups/" + self.groupId + "games").childByAutoId()
            let newGameKey = newGame.key
            
            self.dataRef.child("groups/" + self.groupId + "/games/" + newGameKey).setValue(true)
            
            
            self.dataRef.child("games/" + newGameKey + "/player1").setValue(player1Label.text)
            self.dataRef.child("games/" + newGameKey + "/player2").setValue(player2Label.text)
            self.dataRef.child("games/" + newGameKey + "/player3").setValue(player3Label.text)
            self.dataRef.child("games/" + newGameKey + "/player4").setValue(player4Label.text)

            
            self.dataRef.child("users/" + Functions.getCurrentUserName() + "/currentGame/id").setValue(newGameKey)
            self.dataRef.child("users/" + Functions.getCurrentUserName() + "/currentGame/currentTurn").setValue(1)

            self.navigationController?.popViewControllerAnimated(true)
            
        }
        else{
             Functions.alert("There must be 4 players in a game!")
        }
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
