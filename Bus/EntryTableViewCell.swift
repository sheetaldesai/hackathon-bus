//
//  EntryTableViewCell.swift
//  Bus
//
//  Created by Yukie Hirano on 11/11/17.
//  Copyright © 2017 Sheetal Desai. All rights reserved.
//

import UIKit

class EntryTableViewCell: UITableViewCell {

    @IBOutlet weak var routes: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
