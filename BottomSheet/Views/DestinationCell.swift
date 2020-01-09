//
//  DestinationCell.swift
//  BottomSheet
//
//  Created by Vinoth on 8/1/20.
//  Copyright © 2020 Vinoth. All rights reserved.
//

import UIKit

class DestinationCell: UITableViewCell {

    @IBOutlet weak var locationImage: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var subtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        locationImage.tintColor = UIColor.darkGray
        title.textColor = UIColor.black
        subtitle.textColor = UIColor.darkGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
