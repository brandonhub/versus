//
//  GameOverViewController.swift
//  versus
//
//  Created by Brandon Meeks on 12/3/16.
//  Copyright © 2016 meeks. All rights reserved.
//

import UIKit
import Firebase

class GameOverViewController: UIViewController {
    
    var dataRef: FIRDatabaseReference!
    
    var currentGameId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        
//        dataRef = FIRDatabase.database().reference()
//        
//        dataRef.child("games/" + self.currentGameId).observeSingleEventOfType(.Value, withBlock: {(game) in
//            self.name1.text = game.value!["player1"] as! String!
//            self.name2.text = game.value!["player2"] as! String!
//            self.name3.text = game.value!["player3"] as! String!
//            self.name4.text = game.value!["player4"] as! String!
//
//            self.score1.text = game.value!["team1Points"]
//            self.score2.text = game.value!["team2Points"]
//            
//            var names = [name1.text, name2.text, name3.text, name4.text]
//            var plunks = [Int]()
//            var plinks = [Int]()
//            var points = [Int]()
//            var diff = [Int]()
//
//            
//        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
