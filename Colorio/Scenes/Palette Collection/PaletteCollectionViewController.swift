//
//  PaletteCollectionViewController.swift
//  Colorio
//
//  Created by Gregorius Albert on 21/07/22.
//

import UIKit

class PaletteCollectionViewController: UIViewController {

    @IBOutlet var paletteCollectionView: PaletteCollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        paletteCollectionView.setup(viewController: self)
        // Do any additional setup after loading the view.
    }

}

extension PaletteCollectionViewController: PaletteCollectionDelegate {
    func createPalette() {
        
    }
}

extension PaletteCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleColorCell") as! SingleColorTableViewCell
        
        cell.colorName.text = "Crystal Jade"
        cell.colorHex.text = "#FA0FFF"
        cell.color.backgroundColor = .black
        print("======== \(cell)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return paletteArr.count
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        performSegue(withIdentifier: "toDetailIdeasSegue", sender: self)
    }
    
}
