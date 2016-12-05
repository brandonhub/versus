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

class UserProfileViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    var dataRef:FIRDatabaseReference!
    

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    override func viewDidLoad() {
        var funcs: Functions
        
        super.viewDidLoad()
        self.dataRef = FIRDatabase.database().reference()
        
        // Set up Login Button
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["email", "public_profile"]
        view.addSubview(loginButton)
        

        loginButton.frame = CGRect(x: 16, y: view.frame.height - 175, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        view.addSubview(loginButton)
        
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
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User logged out!")
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
            
            if !snapshot.hasChild(username){
                let userData:[String:AnyObject] = ["uid": uid, "photoUrl": profilePictureUrl!]
                self.dataRef.child("users/" + username).updateChildValues(userData)
                print("New account created for ", username)
            }else{
                print("Recognized returning user")
            }
            
        })
    }
    
}
