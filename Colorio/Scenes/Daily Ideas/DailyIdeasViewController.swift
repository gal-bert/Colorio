//
//  ViewController.swift
//  Colorio
//
//  Created by Gregorius Albert on 20/07/22.
//

import UIKit

class DailyIdeasViewController: UIViewController {
    
    @IBOutlet var dailyIdeasView: DailyIdeasView!
    
    var paletteArr = [Palette]()
    var titleArr = [String]()
    
    var isFirstTime:Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dailyIdeasView.setup(viewController: self)
        refreshPalette()
        
    }
    
}

extension DailyIdeasViewController: DailyIdeasDelegate {
    func refreshPalette() {
        
        //Disable Button
        dailyIdeasView.refreshButtonOutlet.isEnabled = false
        dailyIdeasView.activityIndicator.startAnimating()
        self.dailyIdeasView.tableView.isUserInteractionEnabled = false
        
        
        //Clear Array
        titleArr.removeAll()
        paletteArr.removeAll()
        UIView.transition(
            with: dailyIdeasView.tableView,
            duration: 0.2,
            options: .transitionCrossDissolve,
            animations:
                { () -> Void in
                    self.dailyIdeasView.tableView.reloadData()
                }, completion: nil);
        
        
        // Get Palette List
        getPaletteList() {
            for names in self.titleArr {
                self.getColorsFromEachCategory(paletteName: names)
            }
            
        }
    }
    
    private func getPaletteList(finished: @escaping () -> Void) -> Void {
        let url = URL(string: "\(Constants.COLORMIND_URL)/list")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            let json = try! JSONSerialization.jsonObject(with: data!) as! [String:Any]
            let parent = json["result"] as! [String]
            
            DispatchQueue.main.sync {
                self.titleArr = parent
            }
            
            finished()
            
        }.resume()
        
    }
    
    private func getColorsFromEachCategory(paletteName:String) -> Void {
        let url = URL(string: "\(Constants.COLORMIND_URL)/api/")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: [
            "model": paletteName
        ])
        
        var rgbCollection = [[Int]]()
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            //            Network.getNetworkResponse(data: data, response: response, error: error)
            let json = try! JSONSerialization.jsonObject(with: data!) as! [String:Any]
            let parent = json["result"] as! [[Int]]
            
            let finalTitle = paletteName.replacingOccurrences(of: "_", with: " ").capitalized
            print(finalTitle)
            
            rgbCollection = parent
            
            
            DispatchQueue.main.sync {
                let palette = Palette(title: finalTitle, color1: rgbCollection[0], color2: rgbCollection[1], color3: rgbCollection[2], color4: rgbCollection[3], color5: rgbCollection[4])
                self.paletteArr.append(palette)
                
                if self.paletteArr.count == self.titleArr.count {
                    self.dailyIdeasView.tableView.reloadData()
                    self.dailyIdeasView.tableView.isUserInteractionEnabled = true
                    self.dailyIdeasView.refreshButtonOutlet.isEnabled = true
                    self.dailyIdeasView.activityIndicator.stopAnimating()
                }
                
            }
            
        }.resume()
        
        
    }
    
}

extension DailyIdeasViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paletteCell") as! PaletteTableViewCell
        
        cell.paletteTitle.text = titleArr[indexPath.section].replacingOccurrences(of: "_", with: " ").capitalized
        
        let rawColor = paletteArr[indexPath.section]
        
        print(rawColor.color1)
        
        cell.color1.backgroundColor = UIColor(
            displayP3Red: CGFloat(rawColor.color1[0])/255.0,
            green: CGFloat(rawColor.color1[1])/255.0,
            blue: CGFloat(rawColor.color1[2])/255.0,
            alpha: 1.0
        )
        
        cell.color2.backgroundColor = UIColor(
            displayP3Red: CGFloat(rawColor.color2[0])/255.0,
            green: CGFloat(rawColor.color2[1])/255.0,
            blue: CGFloat(rawColor.color2[2])/255.0,
            alpha: 1.0
        )
        
        cell.color3.backgroundColor = UIColor(
            displayP3Red: CGFloat(rawColor.color3[0])/255.0,
            green: CGFloat(rawColor.color3[1])/255.0,
            blue: CGFloat(rawColor.color3[2])/255.0,
            alpha: 1.0
        )
        
        cell.color4.backgroundColor = UIColor(
            displayP3Red: CGFloat(rawColor.color4[0])/255.0,
            green: CGFloat(rawColor.color4[1])/255.0,
            blue: CGFloat(rawColor.color4[2])/255.0,
            alpha: 1.0
        )
        
        cell.color5.backgroundColor = UIColor(
            displayP3Red: CGFloat(rawColor.color5[0])/255.0,
            green: CGFloat(rawColor.color5[1])/255.0,
            blue: CGFloat(rawColor.color5[2])/255.0,
            alpha: 1.0
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return paletteArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
}

