//
//  GroupDetailViewController.swift
//  versus
//
//  Created by Brandon Meeks on 11/28/16.
//  Copyright © 2016 meeks. All rights reserved.
//

import UIKit
import Firebase

class GroupDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var groupId:String!
    var groupTitle: String!
    
    var plunkLeaders = [Leader]()
    var catchLeaders = [Leader]()
    var performanceLeaders = [Leader]()
    var plunkDataFetched = false
    var catchDataFetched = false
    var perfDataFetches = false
    
    var dataRef:FIRDatabaseReference!
    
    @IBOutlet weak var selectedLeaderBoard: UISegmentedControl!
    @IBOutlet weak var leaderView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.groupTitle!
        self.dataRef = FIRDatabase.database().reference()
        leaderView.delegate = self
        leaderView.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        Functions.getLeaderboardPlunks(groupId, callback: {plunkData in
            for (index, (name, score)) in plunkData.enumerate(){
                var next = Leader()
                next.place = index + 1
                next.name = name
                next.score = score
                next.type = "plunk"
                if (self.plunkLeaders.count > 0 && next.score == self.plunkLeaders.last!.score){
                    next.place = self.plunkLeaders.last!.place
                }
                self.plunkLeaders.append(next)
            }
            self.leaderView.reloadData()
        })
        Functions.getLeaderboardCatchPercentage(groupId, callback: {catchData in
            for (index, (name, score)) in catchData.enumerate(){
                var next = Leader()
                next.place = index + 1
                next.name = name
                next.score = score
                next.type = "catch"
                if (self.catchLeaders.count > 0 && next.score == self.catchLeaders.last!.score){
                    next.place = self.catchLeaders.last!.place
                }
                self.catchLeaders.append(next)
            }
        })
        Functions.getLeaderboardPER(groupId, callback: {perfData in
            for (index, (name, score)) in perfData.enumerate(){
                var next = Leader()
                next.place = index + 1
                next.name = name
                next.score = score
                next.type = "performance"
                if (self.performanceLeaders.count > 0 && next.score == self.performanceLeaders.last!.score){
                    next.place = self.performanceLeaders.last!.place
                }
                self.performanceLeaders.append(next)
            }
        })
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
    }
    
    @IBAction func switchLeaderBoard(sender: UISegmentedControl) {
        leaderView.reloadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (selectedLeaderBoard.selectedSegmentIndex == 0){
            return plunkLeaders.count
        }
        if (selectedLeaderBoard.selectedSegmentIndex == 1){
            return catchLeaders.count
        }
        return performanceLeaders.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = LeaderBoardCell()
        cell = tableView.dequeueReusableCellWithIdentifier("LeaderCell") as! LeaderBoardCell
        if (selectedLeaderBoard.selectedSegmentIndex == 0){
            cell.leader = plunkLeaders[indexPath.row]
        }
        else if (selectedLeaderBoard.selectedSegmentIndex == 1){
            cell.leader = catchLeaders[indexPath.row]
        }
        else {
            cell.leader = performanceLeaders[indexPath.row]
        }
        return cell
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
