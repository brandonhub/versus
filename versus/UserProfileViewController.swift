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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataRef = FIRDatabase.database().reference()
        
        let loginButton = FBSDKLoginButton()
        loginButton.readPermissions = ["email", "public_profile"]
        view.addSubview(loginButton)
        

        loginButton.frame = CGRect(x: 16, y: 50, width: view.frame.width - 32, height: 50)
        loginButton.delegate = self
        view.addSubview(loginButton)
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
        // now check if username already exists
        
        print(self.dataRef)

        self.dataRef.child("users").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            let uid = user.uid
            if !snapshot.hasChild(username){
                self.dataRef.child("users").child(username).setValue([
                    "uid": uid
                ])
                print("New account created for ", username)
            }else{
                print("Recognized returning user")
            }
            
        })
        
        
    }
    
}
