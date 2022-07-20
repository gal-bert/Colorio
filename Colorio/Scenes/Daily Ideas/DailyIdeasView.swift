//
//  DailyIdeasView.swift
//  Colorio
//
//  Created by Gregorius Albert on 20/07/22.
//

import Foundation
import UIKit

protocol DailyIdeasDelegate: AnyObject {
    func refreshPalette()
}

class DailyIdeasView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var refreshButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var delegate:DailyIdeasDelegate!
    
    func setup(viewController: DailyIdeasViewController) {
        delegate = viewController
        tableView.delegate = viewController
        tableView.dataSource = viewController
        tableView.register(UINib(nibName: "PaletteTableViewCell", bundle: nil), forCellReuseIdentifier: "paletteCell")

    }
    
    @IBAction func refreshButton(_ sender: Any) {
        delegate?.refreshPalette()
    }
    
}
