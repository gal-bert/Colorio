//
//  DailyIdeasDetailView.swift
//  Colorio
//
//  Created by Gregorius Albert on 21/07/22.
//

import UIKit

protocol DailyIdeasDetailDelegate {
    
}

class DailyIdeasDetailView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: DailyIdeasDetailDelegate!
    
    func setup(viewController: DailyIdeasDetailViewController) {
        delegate = viewController
        tableView.delegate = viewController
        tableView.dataSource = viewController
        tableView.register(UINib(nibName: "SingleColorTableViewCell", bundle: nil), forCellReuseIdentifier: "singleColorCell")
        
    }
    
}

