//
//  CurrentGameViewController.swift
//  versus
//
//  Created by Brandon Meeks on 11/29/16.
//  Copyright © 2016 meeks. All rights reserved.
//

import UIKit
import Firebase

class CurrentGameViewController: UIViewController {
    
    var dataRef:FIRDatabaseReference!
    var currentGameId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataRef = FIRDatabase.database().reference()
        
        dataRef.child("users/" + Functions.getCurrentUserName() + "/currentGame").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            if !snapshot.exists() {
                self.currentGameId = "NONE"
                
            }else{
                self.currentGameId = snapshot.value as! String!
                print(self.currentGameId)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }



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
