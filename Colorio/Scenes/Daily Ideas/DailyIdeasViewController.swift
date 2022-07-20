//
//  ViewController.swift
//  Colorio
//
//  Created by Gregorius Albert on 20/07/22.
//

import UIKit

class DailyIdeasViewController: UIViewController {

    @IBOutlet var dailyIdeasView: DailyIdeasView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dailyIdeasView.setup(viewController: self)
        refreshPalette()
    }
    
    
}

extension DailyIdeasViewController: DailyIdeasDelegate {
    func refreshPalette() {
        // TODO: Fetch data from Colormind API
    }
}

extension DailyIdeasViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paletteCell") as! PaletteTableViewCell

//        TODO: Assign title on each row
//        cell.paletteTitle = colorArray[indexPath.row]
        
//        TODO: Assign color on each view box
//        cell.color1.backgroundColor = .black
//        cell.color2.backgroundColor = .black
//        cell.color3.backgroundColor = .black
//        cell.color4.backgroundColor = .black
//        cell.color5.backgroundColor = .black
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    
    
}

