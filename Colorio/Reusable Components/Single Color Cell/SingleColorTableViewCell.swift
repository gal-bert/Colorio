//
//  SingleColorTableViewCell.swift
//  Colorio
//
//  Created by Gregorius Albert on 21/07/22.
//

import UIKit

class SingleColorTableViewCell: UITableViewCell {

    @IBOutlet weak var colorName: UILabel!
    @IBOutlet weak var colorHex: UILabel!
    @IBOutlet weak var color: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        color.clipsToBounds = true
        color.layer.cornerRadius = 10
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
