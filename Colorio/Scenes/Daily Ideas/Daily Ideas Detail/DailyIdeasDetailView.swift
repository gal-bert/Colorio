//
//  DailyIdeasDetailView.swift
//  Colorio
//
//  Created by Gregorius Albert on 21/07/22.
//

import UIKit

protocol DailyIdeasDetailDelegate {
    func addToCollection()
}

class DailyIdeasDetailView: UIView {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heartButtonOutlet: UIBarButtonItem!
    
    var delegate: DailyIdeasDetailDelegate!
    
    func setup(viewController: DailyIdeasDetailViewController) {
        delegate = viewController
        tableView.delegate = viewController
        tableView.dataSource = viewController
        tableView.register(UINib(nibName: "SingleColorTableViewCell", bundle: nil), forCellReuseIdentifier: "singleColorCell")
        
    }
    
    @IBAction func heartButton(_ sender: Any) {
        delegate.addToCollection()
    }
    
    
}

