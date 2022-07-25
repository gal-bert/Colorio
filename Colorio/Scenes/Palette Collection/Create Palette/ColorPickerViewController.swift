//
//  ColorPickerViewController.swift
//  Colorio
//
//  Created by Gregorius Albert on 23/07/22.
//

import UIKit

protocol ColorPickerDelegate {
    func getColorValueOnDismiss()
}

class ColorPickerViewController: UIColorPickerViewController, UIAdaptivePresentationControllerDelegate {
    
    var pickerDelegate: ColorPickerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.isModalInPresentation = true
        self.presentationController?.delegate = self
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        pickerDelegate?.getColorValueOnDismiss()
    }
    
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        return false
    }
    
}
