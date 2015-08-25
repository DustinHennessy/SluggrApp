//
//  MemberTravelTableViewCell.swift
//  SluggrApp
//
//  Created by Dustin Hennessy on 8/25/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

import UIKit

class MemberTravelTableViewCell: UITableViewCell {
    
    @IBOutlet var dynamicDepartLabel :UILabel!
    @IBOutlet var dynamicDetailDepartLabel :UILabel!
    @IBOutlet var dynamicDestLabel :UILabel!
    @IBOutlet var dynamicDetailDestLabel :UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}