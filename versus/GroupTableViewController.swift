//
//  GroupTableViewController.swift
//  versus
//
//  Created by Brandon Meeks on 11/8/16.
//  Copyright © 2016 meeks. All rights reserved.
//

import UIKit
import Firebase

class GroupTableViewController: UITableViewController {
    
    var dataRef: FIRDatabaseReference!
    var groups = [Group]()
    
    override func viewWillAppear(animated: Bool) {
<<<<<<< HEAD
        // Functions.getLeaderboardPlunks("KXs6jRFSUtcbbyrEbvS")
=======
        //Functions.getLeaderboardPlunks("KXs6jRFSUtcbbyrEbvS")
>>>>>>> d6ac9432ac14131c0e677dd5e2d5be32b4fc2198
        groups.removeAll()
        self.dataRef = FIRDatabase.database().reference()
        
        
        if (!Functions.loggedIn()){
            let err = UIAlertController(title: "No User Logged In", message: "You are not logged in. In order to use the Groups and Play tabs, you must log into a valid user profile", preferredStyle: .Alert)
            err.addAction(UIAlertAction(title: "Log In", style: .Cancel, handler: {action in
                self.tabBarController?.selectedIndex = 0
            }))
            self.presentViewController(err, animated: true, completion: nil)
        }
        else{
            dataRef.child("users/" + Functions.getCurrentUserName() + "/groups").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                for child in snapshot.children {
                    let childSnapshot = snapshot.childSnapshotForPath(child.key)
                    
                    let title = childSnapshot.value!["title"] as! String
                    let id = child.key!
                    
                    let group = Group(title: title, groupId: id)
                    self.groups.append(group)
                }
                self.tableView.reloadData()
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        
        
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return groups.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        let group = groups[indexPath.row]
        // Configure the cell...
        cell.textLabel?.text = group.title

        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == "groupDetailSegue" {
            
            let destination = segue.destinationViewController as! GroupDetailViewController
            let groupIndex = tableView.indexPathForSelectedRow?.row
            
            // Pass in necessary information for intial view presentation
            let group = groups[groupIndex!]
            destination.groupTitle = group.title
            destination.groupId = group.groupId
            
            
        }
    }

    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
