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
    @IBOutlet weak var name1: UILabel!
    @IBOutlet weak var name2: UILabel!
    @IBOutlet weak var name3: UILabel!
    @IBOutlet weak var name4: UILabel!
    @IBOutlet weak var score1: UILabel!
    @IBOutlet weak var score2: UILabel!
    @IBOutlet weak var plunkLeader: UILabel!
    @IBOutlet weak var plinkLeader: UILabel!
    @IBOutlet weak var pointLeader: UILabel!
    @IBOutlet weak var diffLeader: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataRef = FIRDatabase.database().reference()
        
        
        
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
