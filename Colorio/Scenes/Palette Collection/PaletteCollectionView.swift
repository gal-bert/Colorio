//
//  PaletteCollectionView.swift
//  Colorio
//
//  Created by Gregorius Albert on 21/07/22.
//

import UIKit

protocol PaletteCollectionDelegate: AnyObject {
    func createPalette()
}

class PaletteCollectionView:UIView {
    
    
    @IBOutlet weak var addButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: PaletteCollectionDelegate!
    
    func setup(viewController: PaletteCollectionViewController) {
        delegate = viewController
        tableView.delegate = viewController
        tableView.dataSource = viewController
        tableView.register(UINib(nibName: "SingleColorTableViewCell", bundle: nil), forCellReuseIdentifier: "singleColorCell")

    }
    
    @IBAction func addButton(_ sender: Any) {
        delegate.createPalette()
    }
    
    
}
