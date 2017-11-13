//
//  sTableViewCell.swift
//  Bus
//
//  Created by Yukie Hirano on 11/12/17.
//  Copyright © 2017 Sheetal Desai. All rights reserved.
//

import UIKit

class sTableViewCell: UITableViewCell {

    @IBOutlet weak var lblEta: UILabel!
    @IBOutlet weak var lblroute: UILabel!
    @IBOutlet weak var lblAm: UILabel!
    @IBOutlet weak var lblPm: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
