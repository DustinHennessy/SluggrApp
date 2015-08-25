//
//  ProfileLabelTableViewCell.swift
//  SluggrApp
//
//  Created by Dustin Hennessy on 8/24/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

import UIKit

class ProfileLabelTableViewCell: UITableViewCell {
    
    @IBOutlet var dynamicLCLabel :UILabel!
    @IBOutlet var dynamicLCDetailLabel :UILabel!
    @IBOutlet var invisButton :UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

