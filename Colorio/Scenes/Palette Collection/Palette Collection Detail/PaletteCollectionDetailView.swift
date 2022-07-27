//
//  PaletteCollectionView.swift
//  Colorio
//
//  Created by Gregorius Albert on 27/07/22.
//

import UIKit

protocol PaletteCollectionDetailDelegate {
    func pushPopOver()
}

class PaletteCollectionDetailView: UIView {
    
    @IBOutlet weak var ellipsisButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var delegatexx: PaletteCollectionDetailDelegate!
    
    func setup(viewController: PaletteCollectionDetailViewController) {
        tableView.delegate = viewController
        tableView.dataSource = viewController
        tableView.register(UINib(nibName: "SingleColorTableViewCell", bundle: nil), forCellReuseIdentifier: "singleColorCell")
    }
    
    @IBAction func ellipsisButton(_ sender: Any) {
        delegatexx.pushPopOver()
    }
}
