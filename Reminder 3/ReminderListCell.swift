//
//  ReminderListCell.swift
//  Reminder 3
//
//  Created by Shafiq Aradi on 4/3/16.
//  Copyright © 2016 Shafiq Aradi. All rights reserved.
//

import UIKit

class ReminderListCell: UITableViewCell {

    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
