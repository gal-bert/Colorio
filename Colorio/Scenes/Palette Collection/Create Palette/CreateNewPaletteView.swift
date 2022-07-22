//
//  CreateNewPaletteView.swift
//  Colorio
//
//  Created by Gregorius Albert on 22/07/22.
//

import UIKit

protocol CreateNewPaletteDelegate {
    func pushPickerViewController()
}

class CreateNewPaletteView: UIView {
    
    @IBOutlet weak var singleCard: UIView!
    @IBOutlet weak var colorBox: UIView!
    @IBOutlet weak var colorName: UILabel!
    @IBOutlet weak var colorHexValue: UILabel!
    @IBOutlet weak var colorRgbValue: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: CreateNewPaletteDelegate!
    
    func setup(viewController: CreateNewPaletteViewController) {
        delegate = viewController
        tableView.delegate = viewController
        tableView.dataSource = viewController
        tableView.register(UINib(nibName: "SingleColorTableViewCell", bundle: nil), forCellReuseIdentifier: "singleColorCell")
        
        colorBox.layer.cornerRadius = 10
        singleCard.layer.cornerRadius = 10
        
    }
    
    @IBAction func pickerButton(_ sender: Any) {
        delegate.pushPickerViewController()
    }
    
}
