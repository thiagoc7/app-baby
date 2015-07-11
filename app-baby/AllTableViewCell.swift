//
//  AllTableViewCell.swift
//  app-baby
//
//  Created by Thiago Boucas Correa on 7/6/15.
//  Copyright (c) 2015 Thiago Boucas Correa. All rights reserved.
//

import UIKit

class AllTableViewCell: UITableViewCell {
    
    @IBOutlet weak var sideLabel: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var left: UILabel!
    @IBOutlet weak var right: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
