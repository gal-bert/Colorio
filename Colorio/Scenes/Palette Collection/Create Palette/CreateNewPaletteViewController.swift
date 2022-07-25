//
//  CreateNewPaletteViewController.swift
//  Colorio
//
//  Created by Gregorius Albert on 22/07/22.
//

import UIKit

class CreateNewPaletteViewController: UIViewController {

    
    @IBOutlet var createNewPaletteView: CreateNewPaletteView!
    
    var rgbString:String = ""
    var globalColor:UIColor?
    var colorArr = [Color]()
    var rgbCollection = [[Int]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNewPaletteView.setup(viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "New Palette"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func emptyLoadingContent() -> Void {
        colorArr.removeAll()
        createNewPaletteView.colorName.text = "Loading..."
        createNewPaletteView.colorHexValue.text = "Loading..."
        createNewPaletteView.colorRgbValue.text = "Loading..."
        createNewPaletteView.tableView.reloadData()
    }
    
    func getSingleColorValueAndPalette(rgbString:String) -> Void {
        
        emptyLoadingContent()
        
        let url = URL(string: "\(Constants.THECOLORAPI_RGB_URL)\(rgbString)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            let json = try! JSONSerialization.jsonObject(with: data!) as! [String:Any]
            
            let name = json["name"] as! [String:Any]
            let nameValue = name["value"] as! String
            
            let hex = json["hex"] as! [String:Any]
            let hexValue = hex["value"] as! String
            
            DispatchQueue.main.sync {
                self.createNewPaletteView.colorName.text = nameValue
                self.createNewPaletteView.colorHexValue.text = hexValue
                self.createNewPaletteView.colorRgbValue.text = "RGB(\(rgbString))"
                self.getPalette()
            }
            
        }.resume()
        
    }
    
    func getPalette() -> Void {
            
        let uIntColor = globalColor?.rgb
        let red = uIntColor![0]
        let green = uIntColor![1]
        let blue = uIntColor![2]
        
        let url = URL(string: "\(Constants.COLORMIND_API_URL)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        request.httpBody = try! JSONSerialization.data(withJSONObject: [
            "input": [[red, green, blue]],
            "model": "default"
        ])
        
//        print("\n\n\( String(decoding: request.httpBody!, as: UTF8.self) )\n\n")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            let json = try! JSONSerialization.jsonObject(with: data!) as! [String:Any]
            
            let result = json["result"] as! [[Int]]
            
            DispatchQueue.main.sync {
                self.rgbCollection = result
                self.loadToTableView(index: 0)
            }
            
        }.resume()
        
    }
    
    
    func loadToTableView(index: Int) -> Void {
        
        guard index < 5 else { return }
        
        var param = "\(rgbCollection[index])"
        param = param.replacingOccurrences(of: "[", with: "(").replacingOccurrences(of: "]", with: ")")
        print("Param = \(param)")
        
        let url = URL(string: "\(Constants.THECOLORAPI_RGB_URL)\(param)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            let json = try! JSONSerialization.jsonObject(with: data!) as! [String:Any]
            
            let name = json["name"] as! [String:Any]
            let nameValue = name["value"] as! String
            
            let hex = json["hex"] as! [String:Any]
            let hexValue = hex["value"] as! String
            
            DispatchQueue.main.sync {
                let color = Color(name: nameValue, hex: hexValue, red: self.rgbCollection[index][0], green: self.rgbCollection[index][1], blue: self.rgbCollection[index][2])
                self.colorArr.append(color)
                self.createNewPaletteView.tableView.insertSections(IndexSet(integer: index), with: .fade)
            }
            
            self.loadToTableView(index: index+1)
            
        }.resume()
        
    }
    
    

}

extension CreateNewPaletteViewController: CreateNewPaletteDelegate {
    func pushPickerViewController(pickerVC: UIColorPickerViewController) {
        createNewPaletteView.pickerVC.isModalInPresentation = true
        createNewPaletteView.pickerVC.pickerDelegate = self
        present(createNewPaletteView.pickerVC, animated: true)
    }

}

extension CreateNewPaletteViewController: UIColorPickerViewControllerDelegate, ColorPickerDelegate {
    
    func getColorValueOnDismiss() {
        let color = createNewPaletteView.pickerVC.selectedColor
        globalColor = color
        
        rgbString = "\(color.rgb)"
            .replacingOccurrences(of: "[", with: "(")
            .replacingOccurrences(of: "]", with: ")")
        
//        createNewPaletteView.colorRgbValue.text = "RGB\(rgbString)"
        createNewPaletteView.colorBox.backgroundColor = color
        getSingleColorValueAndPalette(rgbString: rgbString)

    }
    
}

extension CreateNewPaletteViewController: UITableViewDelegate, UITableViewDataSource {
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
