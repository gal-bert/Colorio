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
    
    var nameArr = [String]()
    var hexArr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.paletteCollectionDetailView.setup(viewController: self)
        
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
        
        fetchAPI(index: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
        paletteCollectionDetailView.activityIndicator.startAnimating()
    }
    
    func setupNavigationBar() {
        self.title = sentPalletes?.paletteName
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func fetchAPI(index: Int) {
        
        guard index < 5 else {
            DispatchQueue.main.async {
                self.paletteCollectionDetailView.activityIndicator.stopAnimating()
            }
            return
        }
        
        let string = "\(colorArr[index])"
            .replacingOccurrences(of: "[", with: "(")
            .replacingOccurrences(of: "]", with: ")")
        
        let url = URL(string: "\(Constants.THECOLORAPI_RGB_URL)\(string)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
        print("URL \(url)")
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            let json = try! JSONSerialization.jsonObject(with: data!) as! [String:Any]
            
            let name = json["name"] as! [String:Any]
            let nameValue = name["value"] as! String
            
            let hex = json["hex"] as! [String:Any]
            let hexValue = hex["value"] as! String
            
            
            DispatchQueue.main.sync {
                self.nameArr.append(nameValue)
                self.hexArr.append(hexValue)
                self.paletteCollectionDetailView.tableView.insertSections(IndexSet(integer: index), with: .fade)
            }
            
            self.fetchAPI(index: index+1)
                        
        }.resume()
        
        
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
        
        cell.colorName.text = nameArr[indexPath.section]
        cell.colorHex.text = hexArr[indexPath.section]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return nameArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UIPasteboard.general.string = hexArr[indexPath.section]
        showToast(message: "Hex copied to clipboard", seconds: 1)
    }
    
}
