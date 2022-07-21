//
//  PaletteTableViewCell.swift
//  Colorio
//
//  Created by Gregorius Albert on 20/07/22.
//

import UIKit

class PaletteTableViewCell: UITableViewCell {

    @IBOutlet weak var paletteName: UILabel!
    @IBOutlet weak var color1: UIView!
    @IBOutlet weak var color2: UIView!
    @IBOutlet weak var color3: UIView!
    @IBOutlet weak var color4: UIView!
    @IBOutlet weak var color5: UIView!
    

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        color1.clipsToBounds = true
        color1.layer.cornerRadius = 10
        color1.layer.maskedCorners = [Corner.topLeft, Corner.bottomLeft]
        
        color5.clipsToBounds = true
        color5.layer.cornerRadius = 10
        color5.layer.maskedCorners = [Corner.topRight, Corner.bottomRight]
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
