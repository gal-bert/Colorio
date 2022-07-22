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
        paletteCollectionView.setup(viewController: self)
    }

}

extension PaletteCollectionViewController: PaletteCollectionDelegate {
    func createPalette() {
        print("Clicked")
    }
}

extension PaletteCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paletteCell") as! PaletteTableViewCell
        
        // TODO: Init cell data
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: Return count based on data from database
//        return paletteArr.count
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: Segue to collection detail
//        performSegue(withIdentifier: "toDetailIdeasSegue", sender: self)
    }
    
}
