//
//  OrderTableViewCell.swift
//  EStore
//
//  Created by Malak Sadek on 8/12/19.
//  Copyright © 2019 Malak Sadek. All rights reserved.
//

import UIKit

class OrderTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var productQuantityLabel: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
