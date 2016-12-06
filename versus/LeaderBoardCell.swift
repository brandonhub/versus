//
//  LeaderBoardCell.swift
//  versus
//
//  Created by Jared Eisenberg on 12/5/16.
//  Copyright © 2016 meeks. All rights reserved.
//

import UIKit

class LeaderBoardCell: UITableViewCell {
    
    var leader: Leader!{
        didSet{
            rank.text = String(leader.place!)
            player.text = leader.name!
            var suffix = ""
            if (leader.type == "catch"){
                suffix = "%"
            }
            score.text = String(leader.score!) + suffix
        }
    }
    
    @IBOutlet weak var rank: UILabel!
    @IBOutlet weak var player: UILabel!
    @IBOutlet weak var score: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
