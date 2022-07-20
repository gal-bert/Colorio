//
//  PaletteTableViewCell.swift
//  Colorio
//
//  Created by Gregorius Albert on 20/07/22.
//

import UIKit

class PaletteTableViewCell: UITableViewCell {

    @IBOutlet weak var paletteTitle: UILabel!
    @IBOutlet weak var color1: UIView!
    @IBOutlet weak var color2: UIView!
    @IBOutlet weak var color3: UIView!
    @IBOutlet weak var color4: UIView!
    @IBOutlet weak var color5: UIView!
    
    let topLeft = CACornerMask.layerMinXMinYCorner
    let topRight = CACornerMask.layerMaxXMinYCorner
    let bottomLeft = CACornerMask.layerMinXMaxYCorner
    let bottomRight = CACornerMask.layerMaxXMaxYCorner
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("TABLEVIEEWCELL")
        color1.clipsToBounds = true
        color1.layer.cornerRadius = 10
        color1.layer.maskedCorners = [topLeft, bottomLeft]
        
        color5.clipsToBounds = true
        color5.layer.cornerRadius = 10
        color5.layer.maskedCorners = [topRight, bottomRight]
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
