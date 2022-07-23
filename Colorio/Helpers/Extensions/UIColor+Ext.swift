//
//  UIColor+Ext.swift
//  Colorio
//
//  Created by Gregorius Albert on 23/07/22.
//

import UIKit

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    
    var rgb: [UInt] {
        let red = UInt(coreImageColor.red * 255 + 0.5)
        let green = UInt(coreImageColor.green * 255 + 0.5)
        let blue = UInt(coreImageColor.blue * 255 + 0.5)
        return [red, green, blue]
    }
    
}
