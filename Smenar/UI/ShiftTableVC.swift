//
//  ShiftTableVC.swift
//  Smenar
//
//  Created by Martin Berger on 12/05/2020.
//  Copyright © 2020 Martin Berger. All rights reserved.
//


import UIKit
import CoreData
import Foundation
import MHCoreData
extension UITableView {
    func indexPathForView(_ view: UIView) -> IndexPath? {
        let center = view.center
        let viewCenter = self.convert(center, from: view.superview)
        let indexPath = self.indexPathForRow(at: viewCenter)
        return indexPath
    }
}
class MyTableCell : UITableViewCell {
  
    typealias CellElement = Shift
    
    @IBOutlet weak var ShiftCell: UIView!
    
    @IBOutlet weak var MyImage: UIImageView!
    @IBOutlet weak var ShiftDay: UILabel!
    @IBOutlet weak var ShiftStart: UILabel!
    @IBOutlet weak var ShiftEnd: UILabel!
    @IBOutlet weak var TrashButton: UIButton!
    
    static var tableCellPrototype: String { "ShiftCell" }
    
    func selfConfig(with: NSManagedObject) {
        ShiftDay.isHidden = false
        ShiftDay?.text = "\(dateFormat(inDate: with.value(forKey: "startDate") as! Date))"
        ShiftStart?.text  = "Začátek: \(timeFormat(inTime: with.value(forKey: "startTime") as! Date))"
        ShiftEnd?.text  = "Konec: \(timeFormat(inTime: with.value(forKey: "endTime") as! Date))"
        
        switch with.value(forKey: "typeOfShift") as! String {
        case "R":
            MyImage.image = UIImage(named:"R-ICON.png")
        case "O":
            MyImage.image = UIImage(named:"O-ICON.png")
        case "N":
            MyImage.image = UIImage(named:"N-ICON.png")
        case "D":
            MyImage.image = UIImage(named:"D-ICON.png")
            ShiftDay.isHidden = true
            ShiftStart?.text  = "Začátek: \(dateFormat(inDate: with.value(forKey: "startDate") as! Date))"
            ShiftEnd?.text  = "Konec: \(dateFormat(inDate: with.value(forKey: "endDate") as! Date))"
        default:
            break
        }
        
    }
    
}

class ShiftTableVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var myShifts: [NSManagedObject] = []
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.init(red: 0/255, green: 1/255, blue: 39/255, alpha: 1.0)
        self.tableView.separatorColor = UIColor.init(red: 31/255, green: 230/255, blue: 109/255, alpha: 1.0)
        self.tableView.rowHeight = 85
        
        myShifts = getData(.listOfElements, myStartDay: "\(day). \(monthC+1). \(year)", myEndDay: "", myPredicate: "(startDate >= %@)", predicateAdd: "")
        
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myShifts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyTableCell", for: indexPath) as! MyTableCell
        cell.selfConfig(with: myShifts[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85.0

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "shiftDetail", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ShiftAddVC {
            if let index = tableView.indexPathForSelectedRow?.row {
                destination.MyStartDate = dateFormat(inDate: myShifts[index].value(forKey: "startDate") as! Date)
                destination.MyEndDate = dateFormat(inDate: myShifts[index].value(forKey: "endDate") as! Date)
                destination.MyStartTime = timeFormat(inTime: myShifts[index].value(forKey: "startTime") as! Date)
                destination.MyEndTime = timeFormat(inTime: myShifts[index].value(forKey: "endTime") as! Date)
                switch myShifts[index].value(forKey: "typeOfShift") as! String {
                case "R":
                    destination.MyShiftPicker = 0
                case "O":
                    destination.MyShiftPicker = 1
                case "N":
                    destination.MyShiftPicker = 2
                case "D":                    
                    destination.MyShiftPicker = 3
                default:
                    destination.MyShiftPicker = 0
                }
                destination.MyHelpLabel = "Editing"
            }
        }
    }
    
    @IBAction func trashButtonTapped(_ button: UIButton) {
        if let indexPath = self.tableView.indexPathForView(button) {
            let alert = UIAlertController(title: "Odstranit směnu", message: "Opravdu chcete odstranit tuto směnu?", preferredStyle: UIAlertController.Style.alert)

             
             alert.addAction(UIAlertAction(title: "Odstranit", style: UIAlertAction.Style.destructive, handler: { action in
                
                guard let appDelegate =
                  UIApplication.shared.delegate as? AppDelegate else {
                      return
                }
                let managedContext = appDelegate.persistentContainer.viewContext
                managedContext.delete(self.myShifts[indexPath.row])
                APP().saveContext()
                self.viewWillAppear(true)
                
             }))
             alert.addAction(UIAlertAction(title: "Zrušit", style: UIAlertAction.Style.cancel, handler: nil))

            
             self.present(alert, animated: true, completion: nil)
        }
        else {
          let alert = UIAlertController(title: "Chyba!", message: "Směnu se nepodařilo odstranit.", preferredStyle: UIAlertController.Style.alert)

          alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

            self.present(alert, animated: true, completion: nil)
        }
    }
    
}
