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
  @IBOutlet weak var containerView: UIView!
  
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
      self.containerView.layer.borderWidth = 1
      self.containerView.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor
      self.containerView.layer.cornerRadius = 5.0
      self.containerView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
