//
//  FindUserViewControllerTableViewController.swift
//  versus
//
//  Created by Brandon Meeks on 11/28/16.
//  Copyright © 2016 meeks. All rights reserved.
//

import UIKit
import Firebase

protocol UserPickedDelegate: class {
    func userWasPicked(username:String, player: String)
}

class FindUserViewController: UITableViewController {
    
    weak var delegate: UserPickedDelegate? = nil
    
    var currentPlayer:String!
    var currentMembers = Set<String>()
    var groupId:String!
    
    
    var dataRef: FIRDatabaseReference!
    var users = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        users.removeAll()
        self.dataRef = FIRDatabase.database().reference()
        
        dataRef.child("groups/" + self.groupId + "/members").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            for child in snapshot.children {
                let username = child.key!
                self.users.append(username)
            }
            self.tableView.reloadData()
        }) { (error) in
            print(error.localizedDescription)
        }


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

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.users.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath)
        let username = users[indexPath.row]
        cell.textLabel?.text = username
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let username = self.users[indexPath.row]
        if !self.currentMembers.contains(username) {
            
            // celling method on previous view controller
            delegate?.userWasPicked(username, player: self.currentPlayer)
            
            // go back to the previous view controller
            self.navigationController?.popViewControllerAnimated(true)
            
        }else{
            // Member already in game...alert user
            Functions.alert(username + "is already a member of this game!")
        }
       
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
