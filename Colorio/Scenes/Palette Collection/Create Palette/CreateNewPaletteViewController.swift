//
//  CreateNewPaletteViewController.swift
//  Colorio
//
//  Created by Gregorius Albert on 22/07/22.
//

import UIKit

class CreateNewPaletteViewController: UIViewController {

    
    @IBOutlet var createNewPaletteView: CreateNewPaletteView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createNewPaletteView.setup(viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = "New Palette"
        navigationItem.largeTitleDisplayMode = .never
    }

}

extension CreateNewPaletteViewController: CreateNewPaletteDelegate {
    func pushPickerViewController(pickerVC: UIColorPickerViewController) {
        present(createNewPaletteView.pickerVC, animated: true)
    }

}

extension CreateNewPaletteViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        let color = viewController.selectedColor
        let rgbString = "RGB\(color.rgb)"
            .replacingOccurrences(of: "[", with: "(")
            .replacingOccurrences(of: "]", with: ")")
        
        createNewPaletteView.colorRgbValue.text = rgbString
        createNewPaletteView.colorBox.backgroundColor = color
        
        // TODO: Fetch API and set color name and color hex (thecolorapi.com)
        
    }
    
}

extension CreateNewPaletteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "singleColorCell") as! SingleColorTableViewCell
        
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
//        UIPasteboard.general.string = colorArr[indexPath.section].hex
        showToast(message: "Hex copied to clipboard", seconds: 1)
    }
}
