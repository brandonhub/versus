//
//  NewGroupViewController.swift
//  versus
//
//  Created by Brandon Meeks on 11/16/16.
//  Copyright © 2016 meeks. All rights reserved.
//

import UIKit
import Firebase

class NewGroupViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var dataRef: FIRDatabaseReference!
    var members:[String] = [Functions.getCurrentUserName()]
    
    @IBOutlet weak var memberTableView: UITableView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var newMemberField: UITextField!
    
    // table population logic
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("customCell", forIndexPath: indexPath) 
        cell.textLabel?.text = members[indexPath.item]
        return cell
    }

    @IBAction func addUser(sender: AnyObject) {
        
        let username = newMemberField.text
        if username != "" {
            
            self.dataRef.child("users").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if snapshot.hasChild(username!){
                    if self.members.contains(username!) {
                        self.showAlert("User already added")
                    }
                    else{
                        self.members.append(username!)
                        self.memberTableView.reloadData()
                    }
                }else{
                    self.showAlert("User doesn't exist")
                }
            })
            self.newMemberField.text = ""
        
        }
        else{
            Functions.alert("Please enter a username!")
        }
        
    }
        
    @IBAction func cancelGroup(sender: AnyObject) {
       self.dismissViewControllerAnimated(true, completion: {});
    }
    
    @IBAction func createGroup(sender: AnyObject) {
        
        if self.nameField.text != "" {
            
            // get all data that we need
            let newGroupName = self.nameField.text!
            let newGroup = self.dataRef.child("groups").childByAutoId()
            let newGroupKey = newGroup.key
            
            //construct group
            var dictionary =  [String:Bool]()
            for username in self.members{
                dictionary[username] = true
                self.dataRef.child("users/" + username + "/groups/" + newGroupKey).setValue(["title": newGroupName])
            }
            newGroup.child("members").setValue(dictionary)
            newGroup.child("title").setValue(newGroupName)
             newGroup.child("memberCount").setValue(self.members.count)
            self.dismissViewControllerAnimated(true, completion: {});
        }
        else{
            Functions.alert("Group must have a name!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataRef = FIRDatabase.database().reference()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.memberTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAlert(message:String){
        let alertController = UIAlertController(title: "Versus", message:
            message, preferredStyle: UIAlertControllerStyle.Alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
        
        self.presentViewController(alertController, animated: true, completion: nil)
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
