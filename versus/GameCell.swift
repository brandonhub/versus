//
//  GameCell.swift
//  versus
//
//  Created by Brandon Meeks on 12/5/16.
//  Copyright © 2016 meeks. All rights reserved.
//

import UIKit

class GameCell: UITableViewCell {

    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var player2Label: UILabel!
    @IBOutlet weak var player3Label: UILabel!
    @IBOutlet weak var player4Label: UILabel!
    
    @IBOutlet weak var team2ScoreLabel: UILabel!
    @IBOutlet weak var team1ScoreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
