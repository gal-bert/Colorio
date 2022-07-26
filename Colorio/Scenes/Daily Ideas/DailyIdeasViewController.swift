//
//  ViewController.swift
//  Colorio
//
//  Created by Gregorius Albert on 20/07/22.
//

import UIKit
import CoreData

class DailyIdeasViewController: UIViewController {
    
    @IBOutlet var dailyIdeasView: DailyIdeasView!
    
    var paletteArr = [Palette]()
    var titleArr = [String]()
    
    var paletteToSend:Palette?
    
    var isFirstTime:Bool = true
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    
    override func viewDidLoad() {
        super.viewDidLoad()
        dailyIdeasView.setup(viewController: self)
        refreshPalette()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailIdeasSegue" {
            let destination = segue.destination as! DailyIdeasDetailViewController
            destination.palette = paletteToSend
        }
    }
    
    @IBAction func unwindToDailyIdeas(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }
    
}

extension DailyIdeasViewController: DailyIdeasDelegate {
    func refreshPalette() {
        
        //Disable Button
        dailyIdeasView.refreshButtonOutlet.isEnabled = false
        dailyIdeasView.activityIndicator.startAnimating()
        
        
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
            self.getColorsFromEachCategory(index:0)
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
    
    private func getColorsFromEachCategory(index:Int) -> Void {
        
        guard index < titleArr.count else { return }
        
        let paletteName = titleArr[index]
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
                    self.dailyIdeasView.refreshButtonOutlet.isEnabled = true
                    self.dailyIdeasView.activityIndicator.stopAnimating()
                }
                
                self.dailyIdeasView.tableView.insertSections(IndexSet(integer: index), with: .fade)
                
                self.getColorsFromEachCategory(index: index+1)
                
            }
            
        }.resume()
        
        
    }
    
}

extension DailyIdeasViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paletteCell") as! PaletteTableViewCell
        
        if paletteArr[indexPath.section].title == "Ui" || paletteArr[indexPath.section].title == "UI"   {
            paletteArr[indexPath.section].title = "UI"
            cell.paletteName.text = paletteArr[indexPath.section].title.replacingOccurrences(of: "_", with: " ").uppercased()
        } else {
            cell.paletteName.text = paletteArr[indexPath.section].title.replacingOccurrences(of: "_", with: " ").capitalized
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
        paletteToSend = paletteArr[indexPath.section]
        performSegue(withIdentifier: "toDetailIdeasSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let action = UITableViewRowAction(style: .normal, title: "Save") { (action, indexPath) in
            
            let context = self.appDelegate.persistentContainer.viewContext
            context.automaticallyMergesChangesFromParent = true
            context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            
            let pl = Palettes(context: context)
            
            do{
                pl.paletteName = self.paletteArr[indexPath.section].title
                pl.color1 = self.paletteArr[indexPath.section].color1 as NSObject
                pl.color2 = self.paletteArr[indexPath.section].color2 as NSObject
                pl.color3 = self.paletteArr[indexPath.section].color3 as NSObject
                pl.color4 = self.paletteArr[indexPath.section].color4 as NSObject
                pl.color5 = self.paletteArr[indexPath.section].color5 as NSObject
                
                context.insert(pl)
                try context.save()
                print("Save Success")
                
                self.showToast(message: "Saved to collection", seconds: 1)
                
            } catch {
                print(error.localizedDescription)
            }
            
        }
        
        action.backgroundColor = .systemBlue
        
        return [action]
    }
    
    
}

