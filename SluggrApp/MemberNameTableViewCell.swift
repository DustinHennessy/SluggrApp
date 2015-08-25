//
//  MemberNameTableViewCell.swift
//  SluggrApp
//
//  Created by Dustin Hennessy on 8/25/15.
//  Copyright (c) 2015 DustinHennessy. All rights reserved.
//

import UIKit

class MemberNameTableViewCell: UITableViewCell {
    
    @IBOutlet var memberFullNameLabel :UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}