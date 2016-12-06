//
//  GroupDetailViewController.swift
//  versus
//
//  Created by Brandon Meeks on 11/28/16.
//  Copyright © 2016 meeks. All rights reserved.
//

import UIKit
import Firebase

class GroupDetailViewController: UIViewController {
    
    var groupId:String!
    var groupTitle: String!
    var dataRef:FIRDatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.groupTitle!
        self.dataRef = FIRDatabase.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "newGameSegue" {
            let destination = segue.destinationViewController as! NewGameViewController
            destination.groupId = self.groupId
            
        }
        if  segue.identifier == "viewGamesSegue" {
            
            let destination = segue.destinationViewController as! GamesViewController
            destination.groupId = self.groupId
            
        }
    }

}
