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
        
//        tabBarController?.tabBar.items![0].title = "Ideas"
//        tabBarController?.tabBar.items![0].image = UIImage(systemName: "lightbulb")
//        tabBarController?.tabBar.items![1].title = "Palette"
//        tabBarController?.tabBar.items![1].image = UIImage(systemName: "rectangle.3.group")
        
        dailyIdeasView.setup(viewController: self)
        refreshPalette()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = false
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
        let url = URL(string: "\(Constants.COLORMIND_LIST_URL)")!
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
        let url = URL(string: "\(Constants.COLORMIND_API_URL)")!
        var request = URLRequest(url: url)
        
        /// GET Method cannot include httpBody, so use PUT as substitution
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
            
            rgbCollection = parent
            
            DispatchQueue.main.sync {
                let palette = Palette(title: finalTitle, color1: rgbCollection[0], color2: rgbCollection[1], color3: rgbCollection[2], color4: rgbCollection[3], color5: rgbCollection[4])
                self.paletteArr.append(palette)
                
                if self.paletteArr.count == self.titleArr.count {
                    
                    UIView.transition(
                        with: self.dailyIdeasView.tableView,
                        duration: 0.2,
                        options: .transitionCrossDissolve,
                        animations:
                            { () -> Void in
                                self.dailyIdeasView.tableView.reloadData()
                            }, completion: nil);
                    
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
        
        if indexPath.section == 0 {
            cell.paletteName.text = titleArr[indexPath.section].replacingOccurrences(of: "_", with: " ").uppercased()
        } else {
            cell.paletteName.text = titleArr[indexPath.section].replacingOccurrences(of: "_", with: " ").capitalized
        }
        
        let rawColor = paletteArr[indexPath.section]
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "toDetailIdeasSegue", sender: self)
    }
    
    
}

