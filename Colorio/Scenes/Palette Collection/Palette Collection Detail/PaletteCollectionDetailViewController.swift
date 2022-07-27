//
//  PaletteCollectionDetailViewController.swift
//  Colorio
//
//  Created by Gregorius Albert on 27/07/22.
//

import UIKit

class PaletteCollectionDetailViewController: UIViewController {
    
    @IBOutlet var paletteCollectionDetailView: PaletteCollectionDetailView!
    
    var sentPalletes:Palettes?
    var color1:[Int]?
    var color2:[Int]?
    var color3:[Int]?
    var color4:[Int]?
    var color5:[Int]?
    
    var colorArr = [[Int]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paletteCollectionDetailView.setup(viewController: self)
        
        color1 = sentPalletes?.color1 as! [Int]
        color2 = sentPalletes?.color2 as! [Int]
        color3 = sentPalletes?.color3 as! [Int]
        color4 = sentPalletes?.color4 as! [Int]
        color5 = sentPalletes?.color5 as! [Int]
        
        colorArr.append(color1!)
        colorArr.append(color2!)
        colorArr.append(color3!)
        colorArr.append(color4!)
        colorArr.append(color5!)
        
        print("\n===> \(colorArr)\n")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.title = sentPalletes?.paletteName
        navigationItem.largeTitleDisplayMode = .never
    }

}

extension PaletteCollectionDetailViewController: PaletteCollectionDetailDelegate {
    func pushPopOver() {
        print("Button clicked")
        // TODO: Push Popover button
    }
}

extension PaletteCollectionDetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleColorCell") as! SingleColorTableViewCell
        
        let color = colorArr[indexPath.section]
        cell.color.backgroundColor = UIColor(
            displayP3Red: CGFloat(colorArr[indexPath.section][0]) / 255,
            green: CGFloat(colorArr[indexPath.section][1]) / 255,
            blue: CGFloat(colorArr[indexPath.section][2]) / 255,
            alpha: 1.0
        )
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return colorArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
}
