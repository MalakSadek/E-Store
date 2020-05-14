//
//  SearchTableViewCell.swift
//  EStore
//
//  Created by Malak Sadek on 8/18/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
