//
//  EndGameViewController.swift
//  versus
//
//  Created by Jared Eisenberg on 12/6/16.
//  Copyright © 2016 meeks. All rights reserved.
//

import UIKit
import Firebase

class EndGameViewController: UIViewController {

    var dataRef: FIRDatabaseReference!
    
    var currentGameId:String!
    
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var name3: UILabel!
    @IBOutlet weak var name4: UILabel!
    
    @IBOutlet weak var score1: UILabel!
    @IBOutlet weak var score2: UILabel!
    
    @IBOutlet weak var plunkLeader: UILabel!
    @IBOutlet weak var plinkLeader: UILabel!
    @IBOutlet weak var diffLeader: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataRef = FIRDatabase.database().reference()
        
        dataRef.child("games/" + self.currentGameId).observeSingleEventOfType(.Value, withBlock: {(game) in
            self.name1.text = game.value!["player1"] as! String!
            self.name2.text = game.value!["player2"] as! String!
            self.name3.text = game.value!["player3"] as! String!
            self.name4.text = game.value!["player4"] as! String!
            
            self.score1.text = String(game.value!["team1Points"] as! Int!)
            self.score2.text = String(game.value!["team2Points"] as! Int!)
            
            let names = [self.name1.text, self.name2.text, self.name3.text, self.name4.text]
            var plunks = [Int]()
            var plinks = [Int]()
            var points = [Int]()
            var diff = [Int]()
            
            
            
            for p in 0..<names.count{
                let stats = game.value![names[p]!] as! NSDictionary!
            }
                
            
        })


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
