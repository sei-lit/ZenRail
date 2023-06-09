//
//  DestinationTableViewCell.swift
//  ZenRail
//
//  Created by 大森青 on 2023/06/09.
//

import UIKit

class DestinationTableViewCell: UITableViewCell {
    
    @IBOutlet var destinationLabel: UILabel!
    @IBOutlet var trainImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
