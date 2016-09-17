//
//  OutputTableViewCell.swift
//  
//
//  Created by Matz Persson on 16/09/2016.
//
//

import UIKit

class OutputTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var onSwitch: UISwitch!
    @IBOutlet weak var ledImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        ledImage.layer.cornerRadius = ledImage.frame.width / 2
        ledImage.backgroundColor = UIColor.lightGrayColor()
        
        ledImage.layer.borderColor = UIColor.grayColor().CGColor
        ledImage.layer.borderWidth = 1
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }


}
