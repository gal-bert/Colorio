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
    
    var colorArr = [Color]()
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    override func viewDidLoad() {
        super.viewDidLoad()
        dailyIdeasDetailView.setup(viewController: self)
        colorRGBArr.append(palette!.color1)
        colorRGBArr.append(palette!.color2)
        colorRGBArr.append(palette!.color3)
        colorRGBArr.append(palette!.color4)
        colorRGBArr.append(palette!.color5)
        
        dailyIdeasDetailView.activityIndicator.startAnimating()
        fetchData(index: 0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupNavigationBar()
    }
    
    func setupNavigationBar() {
        self.title = palette?.title
        navigationItem.largeTitleDisplayMode = .never
        dailyIdeasDetailView.heartButtonOutlet.isEnabled = false
    }
    
    func fetchData(index:Int) -> Void {
        
        guard index < 5 else {
            DispatchQueue.main.async {
                self.dailyIdeasDetailView.heartButtonOutlet.isEnabled = true
            }
            return
        }
    
        let colorRGB = colorRGBArr[index]
        let red = colorRGB[0]
        let green = colorRGB[1]
        let blue = colorRGB[2]
        
        let colorRGBString = "(\(red),\(green),\(blue))"
        
        let url = URL(string: "\(Constants.THECOLORAPI_RGB_URL)\(colorRGBString)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            let json = try! JSONSerialization.jsonObject(with: data!) as! [String:Any]
            
            let name = json["name"] as! [String:Any]
            let nameValue = name["value"] as! String
            
            let hex = json["hex"] as! [String:Any]
            let hexValue = hex["value"] as! String
            
            
            DispatchQueue.main.sync {
                let color = Color(name: nameValue, hex: hexValue, red: red, green: green, blue: blue)
                self.colorArr.append(color)
                
                if self.colorArr.count == 5 {
                    self.dailyIdeasDetailView.activityIndicator.stopAnimating()
                    
                }

                self.dailyIdeasDetailView.tableView.insertSections(IndexSet(integer: index), with: .fade)
                
            }
            
            self.fetchData(index: index+1)
            
        }.resume()
        
    }
    

}

extension DailyIdeasDetailViewController: DailyIdeasDetailDelegate {
    func addToCollection() {
        
        let context = appDelegate.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
        
        let palettes = Palettes(context: context)
        
        do{
            palettes.paletteName = palette?.title
            palettes.color1 = palette!.color1 as NSObject
            palettes.color2 = palette!.color2 as NSObject
            palettes.color3 = palette!.color3 as NSObject
            palettes.color4 = palette!.color4 as NSObject
            palettes.color5 = palette!.color5 as NSObject
            context.insert(palettes)
            try context.save()
            print("Save Success")
        } catch {
            print(error.localizedDescription)
        }
        
        // TODO: Add alert save success and segue to collection palette
        
    }
}

extension DailyIdeasDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleColorCell") as! SingleColorTableViewCell
        
        let color = colorArr[indexPath.section]
        
        cell.colorHex.text = "\(color.hex)"
        cell.colorName.text = "\(color.name)"
        cell.color.backgroundColor = UIColor(
            displayP3Red: CGFloat(color.red)/255.0,
            green: CGFloat(color.green)/255.0,
            blue: CGFloat(color.blue)/255.0,
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        UIPasteboard.general.string = colorArr[indexPath.section].hex
        showToast(message: "Hex copied to clipboard", seconds: 1)
    }
    
    
}
