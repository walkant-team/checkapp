//
//  EventTableViewCell.swift
//  check
//
//  Created by angelito on 12/27/15.
//  Copyright © 2015 walkant. All rights reserved.
//

import UIKit

class ScheduleTableViewCell: UITableViewCell {
    
    @IBOutlet var scheduleLabel: UILabel!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var addressLabel: UILabel!
    @IBOutlet var checkImageView: UIImageView!
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
  
  override func prepareForReuse() {
    self.checkImageView.image = nil
  }

}
