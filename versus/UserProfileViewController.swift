//
//  UserProfileViewController.swift
//  versus
//
//  Created by Brandon Meeks on 11/14/16.
//  Copyright © 2016 meeks. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import Foundation

class UserProfileViewController: UIViewController, FBSDKLoginButtonDelegate {

    var dataRef:FIRDatabaseReference!

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var winPercentageLabel: UILabel!
    @IBOutlet weak var PERLabel: UILabel!
    @IBOutlet weak var totalPlunksLabel: UILabel!
    @IBOutlet weak var totalCatchesLabel: UILabel!

    override func viewDidLoad() {       
        super.viewDidLoad()
        self.dataRef = FIRDatabase.database().reference()
    }

    override func viewDidAppear(animated: Bool) {
        
        // Set up Login Button
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["email", "public_profile"]
        view.addSubview(loginButton)


        loginButton.frame = CGRect(x: 16, y: view.frame.height - 115, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        view.addSubview(loginButton)
        

        if Functions.loggedIn() {
            // Set up profile image
            self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.width/2
            self.profileImageView.clipsToBounds = true;

            dataRef.child("users/" + Functions.getCurrentUserName() + "/photoUrl").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if !snapshot.exists() { return }
                let urlString = snapshot.value as! String
                let url = NSURL(string: urlString)
                let data = NSData(contentsOfURL: url!)
                self.profileImageView.image = UIImage(data: data!)
            }) { (error) in
                print(error.localizedDescription)
            }

            // Set up username label
            self.usernameLabel.text = Functions.getCurrentUserName()
            
            self.calculateWinPercentage()
            self.calculatePER()
            self.getTotalPlunks()
            self.getTotalCatches()

        }
        else {
            // don't initialize any values
            let userImage = UIImage(named: "user")
            self.profileImageView.image = userImage
            self.usernameLabel.text = ""
            
            self.winPercentageLabel.text = ""
            self.totalCatchesLabel.text = ""
            self.PERLabel.text = ""
            self.totalPlunksLabel.text = ""
        }

    }
    
    func calculateWinPercentage(){
        self.dataRef.child("users/" + Functions.getCurrentUserName() + "/stats").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            let totalGames = snapshot.value!["GAMES"] as! Double!
            let totalWins = snapshot.value!["WINS"] as! Double!
            
            if totalGames != 0 {
                self.winPercentageLabel.text = String(Int(floor(Double(totalWins)/Double(totalGames) * 100))) + "%"
            }
            else{
                self.winPercentageLabel.text = "NA"
            }
        })
        
    }
    
    func calculatePER(){
        self.dataRef.child("users/" + Functions.getCurrentUserName() + "/stats").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            let totalGames = snapshot.value!["GAMES"] as! Double!
            let totalPlunks = snapshot.value!["PLUNKS"] as! Double!
            let totalDrops = snapshot.value!["DROPS"] as! Double!
        
            if totalGames != 0 {
                let per = Int(floor((totalPlunks - totalDrops)*100.0/totalGames))
                self.PERLabel.text = String(per) + "%"
            }
            else{
                self.PERLabel.text = "NA"
            }
        })
        
    }
    
    func getTotalPlunks(){
        self.dataRef.child("users/" + Functions.getCurrentUserName() + "/stats/PLUNKS").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            self.totalPlunksLabel.text = String(snapshot.value as! Int!)
        })
    }
    
    func getTotalCatches(){
        self.dataRef.child("users/" + Functions.getCurrentUserName() + "/stats/CATCHES").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            self.totalCatchesLabel.text = String(snapshot.value as! Int!)
        })
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        Functions.signOutUser()
        self.viewDidAppear(true)
    }

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError?) {
        if error != nil {
            print(error)
            return
        }

        let credentials = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)

        FIRAuth.auth()?.signInWithCredential(credentials, completion: { (user, error) in
            if error != nil {
                print("Firebase authentication failed", error)
                return
            }
            print("Successfully logged in with fb with user: ", user)
            
            self.generateUsernameAndStore(user!)

        })

    }

    func generateUsernameAndStore(user: FIRUser){
        // split name into first and last
        let username = Functions.getCurrentUserName()

        self.dataRef.child("users").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let uid = user.uid
            let profilePictureUrl = user.photoURL?.absoluteString
            print("generating use")
            if !snapshot.hasChild(username){
                let userData:[String:AnyObject] = [
                    "uid": uid,
                    "photoUrl": profilePictureUrl!,
                    "stats": [
                        "CATCHES":0,
                        "PLUNKS":0,
                        "PLINKS":0,
                        "TABLES":0,
                        "DROPS":0,
                        "SHOTS":0,
                        "WINS": 0,
                        "GAMES": 0
                    ]
                ]
                self.dataRef.child("users/" + username).updateChildValues(userData)
                print("New account created for ", username)
                self.viewDidAppear(true)
            }else{
                print("Recognized returning user")
                self.viewDidAppear(true)
            }

        })
    }

}
