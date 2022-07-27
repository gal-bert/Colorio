//
//  PaletteCollectionViewController.swift
//  Colorio
//
//  Created by Gregorius Albert on 21/07/22.
//

import UIKit
import CoreData

class PaletteCollectionViewController: UIViewController {

    @IBOutlet var paletteCollectionView: PaletteCollectionView!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var cloudArr = [Palettes]()
    var paletteToSend:Palettes?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        paletteCollectionView.setup(viewController: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchCloudKit()
        print("\n\n\n\n ==> \(cloudArr.count) \n\n\n\n")
    }
    
    func fetchCloudKit() {
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = Palettes.fetchRequest()
        let result = try! context.fetch(fetchRequest)
        cloudArr = result
        paletteCollectionView.tableView.reloadData()
    }
    
    @IBAction func unwindToPalette(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
    }

}

extension PaletteCollectionViewController: PaletteCollectionDelegate {
    func createPalette() {
        self.performSegue(withIdentifier: "createPaletteSegue", sender: self)
    }
}

extension PaletteCollectionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paletteCell") as! PaletteTableViewCell
        
        let color1 = cloudArr[indexPath.section].color1 as! [Int]
        let color2 = cloudArr[indexPath.section].color2 as! [Int]
        let color3 = cloudArr[indexPath.section].color3 as! [Int]
        let color4 = cloudArr[indexPath.section].color4 as! [Int]
        let color5 = cloudArr[indexPath.section].color5 as! [Int]
        
        cell.paletteName.text = cloudArr[indexPath.section].paletteName
        
        cell.color1.backgroundColor = UIColor(
            displayP3Red: CGFloat(color1[0])/255.0,
            green: CGFloat(color1[1])/255.0,
            blue: CGFloat(color1[2])/255.0,
            alpha: 1.0
        )
        
        cell.color2.backgroundColor = UIColor(
            displayP3Red: CGFloat(color2[0])/255.0,
            green: CGFloat(color2[1])/255.0,
            blue: CGFloat(color2[2])/255.0,
            alpha: 1.0
        )
        
        cell.color3.backgroundColor = UIColor(
            displayP3Red: CGFloat(color3[0])/255.0,
            green: CGFloat(color3[1])/255.0,
            blue: CGFloat(color3[2])/255.0,
            alpha: 1.0
        )
        
        cell.color4.backgroundColor = UIColor(
            displayP3Red: CGFloat(color4[0])/255.0,
            green: CGFloat(color4[1])/255.0,
            blue: CGFloat(color4[2])/255.0,
            alpha: 1.0
        )
        
        cell.color5.backgroundColor = UIColor(
            displayP3Red: CGFloat(color5[0])/255.0,
            green: CGFloat(color5[1])/255.0,
            blue: CGFloat(color5[2])/255.0,
            alpha: 1.0
        )
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // TODO: Check if empty
        return cloudArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        paletteToSend = cloudArr[indexPath.section]
        performSegue(withIdentifier: "toPaletteCollectionDetailSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPaletteCollectionDetailSegue" {
            let dest = segue.destination as! PaletteCollectionDetailViewController
            dest.sentPalletes = paletteToSend
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = self.appDelegate.persistentContainer.viewContext
            context.automaticallyMergesChangesFromParent = true
            context.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
            
            context.delete(self.cloudArr[indexPath.section])
            try! context.save()
            
            self.cloudArr.remove(at: indexPath.section)
            
            self.paletteCollectionView.tableView.deleteSections(IndexSet(integer: indexPath.section), with: .left)
        }
    }
    
}
