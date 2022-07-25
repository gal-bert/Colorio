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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNewPaletteView.setup(viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "New Palette"
        navigationItem.largeTitleDisplayMode = .never
    }
    
    func getSingleColorValue(rgbString:String) -> Void {
        
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
            }
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
        
        rgbString = "\(color.rgb)"
            .replacingOccurrences(of: "[", with: "(")
            .replacingOccurrences(of: "]", with: ")")
        
        createNewPaletteView.colorRgbValue.text = "RGB\(rgbString)"
        createNewPaletteView.colorBox.backgroundColor = color
        getSingleColorValue(rgbString: rgbString)

    }
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        getSingleColorValue(rgbString: rgbString)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        rgbString = "\(color.rgb)"
            .replacingOccurrences(of: "[", with: "(")
            .replacingOccurrences(of: "]", with: ")")
        
        createNewPaletteView.colorRgbValue.text = "RGB\(rgbString)"
        createNewPaletteView.colorBox.backgroundColor = color

        // TODO: Get color palette from colormind.io
    }
    
    
}

extension CreateNewPaletteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleColorCell") as! SingleColorTableViewCell
        
        //TODO: Configure cell items
        
//        let color = colorArr[indexPath.section]
//        
//        cell.colorHex.text = "\(color.hex)"
//        cell.colorName.text = "\(color.name)"
//        cell.color.backgroundColor = UIColor(
//            displayP3Red: CGFloat(color.red)/255.0,
//            green: CGFloat(color.green)/255.0,
//            blue: CGFloat(color.blue)/255.0,
//            alpha: 1.0
//        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return colorArr.count
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // TODO: Implement pasteboard
//        UIPasteboard.general.string = colorArr[indexPath.section].hex
        showToast(message: "Hex copied to clipboard", seconds: 1)
    }
}
