//
//  CheckinTableViewCell.swift
//  check
//
//  Created by angelito on 1/14/16.
//  Copyright © 2016 walkant. All rights reserved.
//

import UIKit

class CheckinTableViewCell: UITableViewCell {
  @IBOutlet weak var checkinDateLabel: UILabel!
  @IBOutlet weak var checkoutDateLabel: UILabel!
  @IBOutlet weak var eventLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
