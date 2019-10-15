//
//  SongDetailTableViewCell.swift
//  BananaPlayer
//
//  Created by Admin on 10/7/19.
//  Copyright © 2019 Chuối. All rights reserved.
//

import UIKit

class SongDetailTableViewCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var artworkImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
