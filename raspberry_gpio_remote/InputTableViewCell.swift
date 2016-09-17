//
//  InputTableViewCell.swift
//  
//
//  Created by Matz Persson on 16/09/2016.
//
//

import UIKit

class InputTableViewCell: UITableViewCell {

    @IBOutlet weak var ledImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        ledImage.layer.cornerRadius = ledImage.frame.width / 2
        ledImage.backgroundColor = UIColor.redColor()
    
        
        ledImage.layer.borderColor = UIColor.grayColor().CGColor
        ledImage.layer.borderWidth = 1
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
