//
//  ColorPickerViewController.swift
//  Colorio
//
//  Created by Gregorius Albert on 23/07/22.
//

import UIKit

class ColorPickerViewController: UIColorPickerViewController, UIAdaptivePresentationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.isModalInPresentation = true
        self.presentationController?.delegate = self
        
        print("DIDLOAD COLOR PICKER")
    }
    
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
