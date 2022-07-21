//
//  CACornerMask+Ext.swift
//  Colorio
//
//  Created by Gregorius Albert on 21/07/22.
//

import Foundation
import QuartzCore

class Corner {
    
    static let topLeft  = CACornerMask.layerMinXMinYCorner
    static let topRight = CACornerMask.layerMaxXMinYCorner
    static let bottomLeft = CACornerMask.layerMinXMaxYCorner
    static let bottomRight = CACornerMask.layerMaxXMaxYCorner
    
}
