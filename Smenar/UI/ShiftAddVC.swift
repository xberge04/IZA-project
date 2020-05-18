//
//  ShiftAddVC.swift
//  Smenar
//
//  Created by Martin Berger on 19/04/2020.
//  Copyright © 2020 Martin Berger. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ShiftAddVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var ShiftPicker: UISegmentedControl!
    
    @IBOutlet weak var StartDay: UITextField!
    
    @IBOutlet weak var StartTime: UITextField!
    
    @IBOutlet weak var EndDay: UITextField!
    
    @IBOutlet weak var EndTime: UITextField!
    
    @IBOutlet weak var SaveButton: UIButton!
    
    @IBOutlet weak var TimeLabel1: UILabel!
    
    @IBOutlet weak var TimeLabel2: UILabel!
    
    @IBOutlet weak var HelpLabel: UILabel!
    
    let datePicker = UIDatePicker()
    
    var MyStartDate: String = "\(dateFormat(inDate: Date()))"
    
    var MyEndDate: String = "\(dateFormat(inDate: Date()))"
    
    var MyStartTime: String = "5:15"
    
    var MyEndTime: String = "13:45"
    
    var MyShiftPicker: Int = 0
    
    var MyHelpLabel: String = ""
    
    @IBAction func shiftChanged(_ sender: Any) {
        if ShiftPicker.selectedSegmentIndex == 0 {
            StartTime.isHidden = false
            EndTime.isHidden = false
            TimeLabel1.isHidden = false
            TimeLabel2.isHidden = false
            StartTime.text = "5:15"
            EndTime.text = "13:45"
            EndDay.text = StartDay.text
        }
        
        else if ShiftPicker.selectedSegmentIndex == 1 {
            StartTime.isHidden = false
            EndTime.isHidden = false
            TimeLabel1.isHidden = false
            TimeLabel2.isHidden = false
            StartTime.text = "13:30"
            EndTime.text = "22:00"
            EndDay.text = StartDay.text
        }
        else if ShiftPicker.selectedSegmentIndex == 2 {
            StartTime.isHidden = false
            EndTime.isHidden = false
            TimeLabel1.isHidden = false
            TimeLabel2.isHidden = false
            StartTime.text = "21:45"
            EndTime.text = "6:15"
            let oldDate = getDate(inDate: EndDay.text!)
            let newDate = Calendar.current.date(byAdding: .day, value: 1, to: oldDate!)
            EndDay.text = "\(dateFormat(inDate: newDate ?? datePicker.date))"
        }
        else if ShiftPicker.selectedSegmentIndex == 3 {
            StartTime.isHidden = true
            EndTime.isHidden = true
            TimeLabel1.isHidden = true
            TimeLabel2.isHidden = true
            EndDay.text = MyEndDate
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let attr = NSDictionary(object: UIFont(name: "Autobus Bold", size: 16.0)!, forKey: NSAttributedString.Key.font as NSCopying)
        ShiftPicker.setTitleTextAttributes(attr as [NSObject : AnyObject] as? [NSAttributedString.Key : Any] , for: .normal)
        
        let bottomLine = CALayer()
        let bottomLine1 = CALayer()
        let bottomLine2 = CALayer()
        let bottomLine3 = CALayer()
        
        StartDay.delegate = self
        EndDay.delegate = self
        StartTime.delegate = self
        EndTime.delegate = self
        
        StartDay.layer.addSublayer(makeLine(bottomLine: bottomLine))
        EndDay.layer.addSublayer(makeLine(bottomLine: bottomLine1))
        StartTime.layer.addSublayer(makeLine(bottomLine: bottomLine2))
        EndTime.layer.addSublayer(makeLine(bottomLine: bottomLine3))
        
        StartDay.text = MyStartDate
        EndDay.text = MyEndDate
        
        StartTime.text = MyStartTime
        EndTime.text = MyEndTime
        
        ShiftPicker.selectedSegmentIndex = MyShiftPicker
        
        HelpLabel.text = MyHelpLabel
        
        shiftChanged(self)
    }
    
    func makeLine(bottomLine: CALayer) -> CALayer {
        bottomLine.frame = CGRect(x: 0, y: StartDay.frame.size.height - 1, width: StartDay.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 75/255, green: 0/255, blue: 176/255, alpha: 1.0).cgColor
        return bottomLine
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.size.height - 1, width: textField.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 33/255, green: 254/255, blue: 128/255, alpha: 1.0).cgColor
        textField.layer.addSublayer(bottomLine)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.size.height - 1, width: textField.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.init(red: 75/255, green: 0/255, blue: 176/255, alpha: 1.0).cgColor
        textField.layer.addSublayer(bottomLine)
    }
    
    @IBAction func startDaySelected(_ sender: Any) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        datePicker.datePickerMode = .date
        datePicker.locale = NSLocale.init(localeIdentifier: "cs_CZ") as Locale
        
        let doneButton1 = UIBarButtonItem(title: "Hotovo", style: .done, target: nil, action: #selector(donePressed1))
        toolbar.setItems([doneButton1], animated: true)
        
        StartDay.inputAccessoryView = toolbar
        
        StartDay.inputView = datePicker
    }
    
    @IBAction func startTimeSelected(_ sender: Any) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        datePicker.datePickerMode = .time
        datePicker.date = getTime(inTime: StartTime.text!)!
        datePicker.minuteInterval = 5
        datePicker.locale = NSLocale.init(localeIdentifier: "cs_CZ") as Locale
        
        let doneButton2 = UIBarButtonItem(title: "Hotovo", style: .done, target: nil, action: #selector(donePressed2))
        toolbar.setItems([doneButton2], animated: true)
        
        StartTime.inputAccessoryView = toolbar
        
        StartTime.inputView = datePicker
    }
    
    
    @IBAction func endTimeSelected(_ sender: Any) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        datePicker.datePickerMode = .time
        datePicker.date = getTime(inTime: EndTime.text!)!
        datePicker.minuteInterval = 5
        datePicker.locale = NSLocale.init(localeIdentifier: "cs_CZ") as Locale
        if ShiftPicker.selectedSegmentIndex != 2 {
            if StartDay.text == EndDay.text {
                datePicker.minimumDate = getTime(inTime: StartTime.text!)
            }
            else{
                datePicker.minimumDate = getTime(inTime: "00:00")
            }
        }
        
        let doneButton3 = UIBarButtonItem(title: "Hotovo", style: .done, target: nil, action: #selector(donePressed3))
        toolbar.setItems([doneButton3], animated: true)
        
        EndTime.inputAccessoryView = toolbar
        
        EndTime.inputView = datePicker
    }
    
    @IBAction func endDaySelected(_ sender: Any) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        datePicker.datePickerMode = .date
        datePicker.locale = NSLocale.init(localeIdentifier: "cs_CZ") as Locale
        datePicker.minimumDate = getDate(inDate: StartDay.text!)
        
        let doneButton4 = UIBarButtonItem(title: "Hotovo", style: .done, target: nil, action: #selector(donePressed4))
        toolbar.setItems([doneButton4], animated: true)
        
        EndDay.inputAccessoryView = toolbar
        
        EndDay.inputView = datePicker
    }
    
    @objc func donePressed1() {
        
        StartDay.text = "\(dateFormat(inDate: datePicker.date))"
        if ShiftPicker.selectedSegmentIndex == 2 {
            let newDate = Calendar.current.date(byAdding: .day, value: 1, to: datePicker.date)
            EndDay.text = "\(dateFormat(inDate: newDate ?? datePicker.date))"
        }
        else {
            EndDay.text = "\(dateFormat(inDate: datePicker.date))"
        }
        self.view.endEditing(true)
    }
    
    @objc func donePressed2() {
        
        StartTime.text = "\(timeFormat(inTime: datePicker.date))"
        var newTime = Calendar.current.date(byAdding: .hour, value: (8), to: datePicker.date)
        newTime = Calendar.current.date(byAdding: .minute, value: (30), to: newTime!)
        EndTime.text = "\(timeFormat(inTime: newTime ?? datePicker.date))"
        
        self.view.endEditing(true)
    }
    
    @objc func donePressed3() {
        
        EndTime.text = "\(timeFormat(inTime: datePicker.date))"
        self.view.endEditing(true)
    }
    
    @objc func donePressed4() {
        
        EndDay.text = "\(dateFormat(inDate: datePicker.date))"
        self.view.endEditing(true)
    }
    
    @IBAction func SaveButton(_ sender: Any) {
        let shifts = getData(.listOfElements, myStartDay: StartDay.text!, myEndDay: "", myPredicate: "(startDate = %@)", predicateAdd: "")
        
        if HelpLabel.text != "Editing" {
            if shifts.count == 0 {
                let newShift = MOC().allocShift()
                
                newShift.startDate = getDate(inDate: StartDay.text!)
                newShift.startTime = getTime(inTime: StartTime.text!)
                newShift.endDate = getDate(inDate: EndDay.text!)
                newShift.endTime = getTime(inTime: EndTime.text!)
                
                if ShiftPicker.selectedSegmentIndex == 0 {
                    newShift.typeOfShift = "R"
                }
                
                else if ShiftPicker.selectedSegmentIndex == 1 {
                    newShift.typeOfShift = "O"
                }
                    
                else if ShiftPicker.selectedSegmentIndex == 2 {
                    newShift.typeOfShift = "N"
                }
                    
                else if ShiftPicker.selectedSegmentIndex == 3 {
                    newShift.typeOfShift = "D"
                }

                APP().saveContext()
                _ = navigationController?.popToRootViewController(animated: true)
            }
            else {
                let alert = UIAlertController(title: "Chyba!", message: "Nemůžete mít dvě směny v jeden den.", preferredStyle: UIAlertController.Style.alert)

                alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                self.present(alert, animated: true, completion: nil)
            }
        }
        else {
            shifts[0].setValue(getTime(inTime: StartTime.text!), forKey: "startTime")
            shifts[0].setValue(getDate(inDate: EndDay.text!), forKey: "endDate")
            shifts[0].setValue(getTime(inTime: EndTime.text!), forKey: "endTime")
            
            if ShiftPicker.selectedSegmentIndex == 0 {
                shifts[0].setValue("R", forKey: "typeOfShift")
            }
            
            else if ShiftPicker.selectedSegmentIndex == 1 {
                shifts[0].setValue("O", forKey: "typeOfShift")
            }
                
            else if ShiftPicker.selectedSegmentIndex == 2 {
                shifts[0].setValue("N", forKey: "typeOfShift")
            }
                
            else if ShiftPicker.selectedSegmentIndex == 3 {
                shifts[0].setValue("D", forKey: "typeOfShift")
            }
            let alert = UIAlertController(title: "Změna směny", message: "Opravdu chcete upravit aktuální data této směny?", preferredStyle: UIAlertController.Style.alert)

            
            alert.addAction(UIAlertAction(title: "Pokračovat", style: UIAlertAction.Style.default, handler: { action in

                APP().saveContext()
                _ = self.navigationController?.popToRootViewController(animated: true)

            }))
            alert.addAction(UIAlertAction(title: "Zrušit", style: UIAlertAction.Style.cancel, handler: nil))

           
            self.present(alert, animated: true, completion: nil)
        }
    }
}

