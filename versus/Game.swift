//
//  Game.swift
//  versus
//
//  Created by Brandon Meeks on 12/5/16.
//  Copyright © 2016 meeks. All rights reserved.
//

import Foundation

class Game {

    var player1:String
    var player2:String
    var player3:String
    var player4:String
    
    var team1Score:Int
    var team2Score:Int
    
    
    init(player1:String, player2:String, player3:String, player4:String, team1Score:Int, team2Score:Int) {
        self.player1 = player1
        self.player2 = player2
        self.player3 = player3
        self.player4 = player4
        
        self.team1Score = team1Score
        self.team2Score = team2Score
    }
    
}
