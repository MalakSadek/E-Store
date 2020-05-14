//
//  MyProductsTableViewCell.swift
//  EStore
//
//  Created by Malak Sadek on 8/12/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

class MyProductsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var stockLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
