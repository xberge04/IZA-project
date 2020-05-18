//
//  WorkedVC.swift
//  Smenar
//
//  Created by Martin Berger on 14/05/2020.
//  Copyright © 2020 Martin Berger. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MHCoreData

class WorkedVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var MonthLabel: UILabel!
    
    @IBOutlet weak var NextButton: UIButton!
    
    var myShifts: [NSManagedObject] = []
    
    var myDay: Int = day
    var myMonth: Int = monthC+1
    var myYear: Int = year
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.init(red: 0/255, green: 1/255, blue: 39/255, alpha: 1.0)
        self.tableView.separatorColor = UIColor.init(red: 31/255, green: 230/255, blue: 109/255, alpha: 1.0)
        self.tableView.rowHeight = 85
        
        MonthLabel.text = "\(Months[myMonth-1]) \(myYear)"
        
        myShifts = getData(.listOfElements, myStartDay: "1. \(myMonth). \(myYear)", myEndDay: "\(myDay). \(myMonth). \(myYear)", myPredicate: "(startDate >= %@) AND (endDate < %@)", predicateAdd: "")
        
        if myMonth == monthC+1 && myYear == year {
            NextButton.isEnabled = false
            myDay = day
        }
        else {
            NextButton.isEnabled = true
            
            myDay = DaysInMonths[myMonth-1]
            if Months[myMonth-1] == "Únor" {
                if myYear % 4 == 0{
                    myDay = 29
                }
            }
        }
        
        tableView.reloadData()
    }
    
    @IBAction func Next(_ sender: Any) {
        switch Months[myMonth-1] {
        case "Prosinec":
            myMonth = 1
            myYear += 1
            
            MonthLabel.text = "\(Months[myMonth-1]) \(myYear)"
            viewWillAppear(true)
            
        default:
            myMonth += 1
            
            MonthLabel.text = "\(Months[myMonth-1]) \(myYear)"
            viewWillAppear(true)
        }
        
        if myMonth == monthC+1 && myYear == year {
            NextButton.isEnabled = false
            myDay = day
        }
        else {
            NextButton.isEnabled = true
            myDay = DaysInMonths[myMonth-1]
            if Months[myMonth-1] == "Únor" {
                if myYear % 4 == 0{
                    myDay = 29
                }
            }
        }

        viewWillAppear(true)
    }
    
    @IBAction func Previous(_ sender: Any) {
        switch Months[myMonth-1] {
        case "Leden":
            myMonth = 12
            myYear -= 1
            
            MonthLabel.text = "\(Months[myMonth-1]) \(myYear)"
            
        default:
            myMonth = myMonth - 1
            
            MonthLabel.text = "\(Months[myMonth-1]) \(myYear)"
        }
        
        if myMonth == monthC+1 && myYear == year {
            NextButton.isEnabled = false
            myDay = day
        }
        else {
            NextButton.isEnabled = true
            myDay = DaysInMonths[myMonth-1]
            if Months[myMonth-1] == "Únor" {
                if myYear % 4 == 0{
                    myDay = 29
                }
            }
        }

        viewWillAppear(true)
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
