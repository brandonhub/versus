//
//  GamesViewController.swift
//  versus
//
//  Created by Brandon Meeks on 12/5/16.
//  Copyright © 2016 meeks. All rights reserved.
//

import UIKit
import Firebase

class GamesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var dataRef:FIRDatabaseReference!
    var games = [Game]()
    var myGames = [Game]()
    var groupId:String!
    @IBOutlet weak var gamesTable: UITableView!
    @IBOutlet weak var gamesTableSelector: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataRef = FIRDatabase.database().reference()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        // populate games table
        self.myGames = []
        self.games = []
        print(self.groupId)
        
        dataRef.child("groups/" + self.groupId + "/games").observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            var i = 0
            for child in snapshot.children {
                self.addGameToArray(child.key,i: i , count: Int(snapshot.childrenCount - 1))
                i = i + 1
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func addGameToArray(gameId:String, i:Int, count:Int) {
        dataRef.child("games/" + gameId).observeSingleEventOfType(.Value, withBlock: { (snapshot) in
            
            let player1 = snapshot.value!["player1"] as! String!
            let player2 = snapshot.value!["player2"] as! String!
            let player3 = snapshot.value!["player3"] as! String!
            let player4 = snapshot.value!["player4"] as! String!

            let team1Score = snapshot.value!["team1Points"] as! Int!
            let team2Score = snapshot.value!["team2Points"] as! Int!
            
            var newGame = Game(player1: player1, player2: player2, player3: player3, player4: player4, team1Score: team1Score, team2Score: team2Score)
            
            self.games.append(newGame)
            
            print(player1 == Functions.getCurrentUserName())
            print(Functions.getCurrentUserName())
            
            if player1 == Functions.getCurrentUserName() || player2 == Functions.getCurrentUserName() || player3 == Functions.getCurrentUserName() || player4 == Functions.getCurrentUserName() {
                
                print("hi")
                self.myGames.append(newGame)
            }
            
            if i == count {
                print("reloading table...")
                self.gamesTable.reloadData()
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func switchGameTable(sender: AnyObject) {
            self.viewDidAppear(true)
    }
    
    // table population logic
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.gamesTableSelector.selectedSegmentIndex == 0 {
            return self.games.count
        }
        return self.myGames.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("gameCell", forIndexPath: indexPath) as! GameCell
        
        if self.gamesTableSelector.selectedSegmentIndex == 0 {
            cell.player1Label.text = games[indexPath.row].player1
            cell.player2Label.text = games[indexPath.row].player2
            cell.player3Label.text = games[indexPath.row].player3
            cell.player4Label.text = games[indexPath.row].player4
            
            cell.team1ScoreLabel.text = String(games[indexPath.row].team1Score)
            cell.team2ScoreLabel.text = String(games[indexPath.row].team2Score)

        }
        else{
            
            cell.player1Label.text = myGames[indexPath.row].player1
            cell.player2Label.text = myGames[indexPath.row].player2
            cell.player3Label.text = myGames[indexPath.row].player3
            cell.player4Label.text = myGames[indexPath.row].player4
            
            cell.team1ScoreLabel.text = String(myGames[indexPath.row].team1Score)
            cell.team2ScoreLabel.text = String(myGames[indexPath.row].team2Score)

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
