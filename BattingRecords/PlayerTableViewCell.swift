//
//  PlayerTableViewCell.swift
//  BattingRecords
//
//  Created by Abhinav Mathur on 11/03/17.
//  Copyright © 2017 Abhinav Mathur. All rights reserved.
//

import UIKit

class PlayerTableViewCell: UITableViewCell {

    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerCountry: UILabel!
    @IBOutlet weak var favourite: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
