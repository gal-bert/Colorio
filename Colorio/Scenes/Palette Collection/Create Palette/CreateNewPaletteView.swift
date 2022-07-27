//
//  CreateNewPaletteView.swift
//  Colorio
//
//  Created by Gregorius Albert on 22/07/22.
//

import UIKit

protocol CreateNewPaletteDelegate {
    func pushPickerViewController(pickerVC: UIColorPickerViewController)
    func reloadPalette()
    func addToFavorite()
}

class CreateNewPaletteView: UIView {
    
    @IBOutlet weak var singleCard: UIView!
    @IBOutlet weak var colorBox: UIView!
    @IBOutlet weak var colorName: UILabel!
    @IBOutlet weak var colorHexValue: UILabel!
    @IBOutlet weak var colorRgbValue: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var reloadPaletteButtonOutlet: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heartButtonOutlet: UIBarButtonItem!
    
    var delegate: CreateNewPaletteDelegate!
    let pickerVC = ColorPickerViewController()
    
    func setup(viewController: CreateNewPaletteViewController) {
        pickerVC.delegate = viewController
        
        delegate = viewController
        tableView.delegate = viewController
        tableView.dataSource = viewController
        tableView.register(UINib(nibName: "SingleColorTableViewCell", bundle: nil), forCellReuseIdentifier: "singleColorCell")
        
        colorBox.layer.cornerRadius = 10
        singleCard.layer.cornerRadius = 10
        
    }
    
    @IBAction func pickerButton(_ sender: Any) {
        delegate.pushPickerViewController(pickerVC: pickerVC)
    }
    
    @IBAction func reloadPaletteButton(_ sender: Any) {
        delegate.reloadPalette()
    }
    
    @IBAction func heartButton(_ sender: Any) {
        delegate.addToFavorite()
    }
}
