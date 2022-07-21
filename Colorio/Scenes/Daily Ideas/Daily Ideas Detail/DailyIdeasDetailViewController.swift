//
//  DailyIdeasDetailViewController.swift
//  Colorio
//
//  Created by Gregorius Albert on 21/07/22.
//

import UIKit

class DailyIdeasDetailViewController: UIViewController {
    
    @IBOutlet var dailyIdeasDetailView: DailyIdeasDetailView!
    
    var palette:Palette?
    var colorRGBArr = [[Int]]()

    override func viewDidLoad() {
        super.viewDidLoad()
        dailyIdeasDetailView.setup(viewController: self)
        colorRGBArr.append(palette!.color1)
        colorRGBArr.append(palette!.color2)
        colorRGBArr.append(palette!.color3)
        colorRGBArr.append(palette!.color4)
        colorRGBArr.append(palette!.color5)
        print(colorRGBArr)
        
        // TODO: Convert from RGB to Hex + Get name from thecolorapi
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.title = palette?.title
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func fetchData() -> Void {
        // TODO: Get color data from API
    }
    

}

extension DailyIdeasDetailViewController: DailyIdeasDetailDelegate {
    func addToCollection() {
        // TODO: Add to Core Data - Cloudkit
        print("Click to collection")
    }
}

extension DailyIdeasDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleColorCell") as! SingleColorTableViewCell
        cell.colorHex.text = "\(colorRGBArr[indexPath.section])"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: Change value based on array content count
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}
