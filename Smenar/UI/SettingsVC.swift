//
//  SettingsVC.swift
//  Smenar
//
//  Created by Martin Berger on 10/05/2020.
//  Copyright © 2020 Martin Berger. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import MHCoreData

class SettingsVC : UIViewController, UITextFieldDelegate {
        
    @IBOutlet weak var Salary: UITextField!
    
    @IBOutlet weak var WorkLoad: UITextField!
    
    @IBOutlet weak var LuncheonPriceLabel: UILabel!
    
    @IBOutlet weak var LuncheonPrice: UITextField!
    
    @IBOutlet weak var LuncheonSwitch: UISwitch!
    
    @IBOutlet weak var Currency: UILabel!
    
    @IBOutlet weak var Holiday: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //if Salary != nil {
            Salary.delegate = self
            WorkLoad.delegate = self
            LuncheonPrice.delegate = self
            Holiday.delegate = self
            
            let bottomLine = CALayer()
            let bottomLine1 = CALayer()
            let bottomLine2 = CALayer()
            let bottomLine3 = CALayer()
            
            let myPurple = UIColor.init(red: 75/255, green: 0/255, blue: 176/255, alpha: 1.0).cgColor
            
            Salary.layer.addSublayer(makeLine(bottomLine: bottomLine, color: myPurple))
            WorkLoad.layer.addSublayer(makeLine(bottomLine: bottomLine1, color: myPurple))
            LuncheonPrice.layer.addSublayer(makeLine(bottomLine: bottomLine2, color: myPurple))
            Holiday.layer.addSublayer(makeLine(bottomLine: bottomLine3, color: myPurple))
        //}
        getData()
    }
    
    @IBAction func Luncheon(_ sender: Any) {
        if LuncheonSwitch.isOn == true {
            LuncheonPrice.isHidden = false
            LuncheonPriceLabel.isHidden = false
            Currency.isHidden = false
        }
        else {
            LuncheonPrice.isHidden = true
            LuncheonPriceLabel.isHidden = true
            Currency.isHidden = true
        }
    }
    
    func makeLine(bottomLine: CALayer, color: CGColor) -> CALayer {
        bottomLine.frame = CGRect(x: 0, y: Salary.frame.size.height - 1, width: Salary.frame.size.width, height: 1)
        bottomLine.backgroundColor = color
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
    
    @IBAction func salarySelected(_ sender: Any) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton1 = UIBarButtonItem(title: "Hotovo", style: .done, target: nil, action: #selector(donePressed1))
        toolbar.setItems([doneButton1], animated: true)
        
        Salary.inputAccessoryView = toolbar
    }
    @IBAction func workLoadSelected(_ sender: Any) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton2 = UIBarButtonItem(title: "Hotovo", style: .done, target: nil, action: #selector(donePressed1))
        toolbar.setItems([doneButton2], animated: true)
        
        WorkLoad.inputAccessoryView = toolbar
    }
    
    
    @IBAction func luncheonSelected(_ sender: Any) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton3 = UIBarButtonItem(title: "Hotovo", style: .done, target: nil, action: #selector(donePressed1))
        toolbar.setItems([doneButton3], animated: true)
        
        LuncheonPrice.inputAccessoryView = toolbar
    }
    
    @IBAction func holidaySelected(_ sender: Any) {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton4 = UIBarButtonItem(title: "Hotovo", style: .done, target: nil, action: #selector(donePressed1))
        toolbar.setItems([doneButton4], animated: true)
        
        Holiday.inputAccessoryView = toolbar
    }
    
    @objc func donePressed1() {
        
        self.view.endEditing(true)
    }
    
    @IBAction func SaveButton(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MySettings")
        fetchRequest.returnsObjectsAsFaults = false

        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in Settings error : \(error) \(error.userInfo)")
        }
        if Salary.text == "" || WorkLoad.text == "" || Holiday.text == "" || (LuncheonSwitch.isOn == true && LuncheonPrice.text == ""){
            let alert = UIAlertController(title: "Chyba!", message: "Musíte vyplnit všechny údaje!", preferredStyle: UIAlertController.Style.alert)

            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: {action in
                for textField in self.view.subviews {
                    if (textField as? UITextField)?.text == "" {
                        self.textNotFilled((textField as? UITextField)!)
                    }
                }
            }))

            
            self.present(alert, animated: true, completion: nil)
        }
        else {
            let newSettings = MOC().allocSettings()
            
            newSettings.salary = Double(Salary.text!)! as Double
            newSettings.workLoad = Double(WorkLoad.text!)! as Double
            newSettings.holidayDays = Double(Holiday.text!)! as Double
            if LuncheonSwitch.isOn == true {
                newSettings.luncheon = true
                newSettings.luncheonPrice = Double(LuncheonPrice.text!)! as Double
            }
            else {
                newSettings.luncheon = false
                newSettings.luncheonPrice = 0
            }
            
            APP().saveContext()
            UserDefaults.standard.set(true, forKey: "Walkthrough")
            _ = navigationController?.popToRootViewController(animated: true)
        }
    }
    
    func textNotFilled(_ textField: UITextField) {
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: textField.frame.size.height - 1, width: textField.frame.size.width, height: 1)
        bottomLine.backgroundColor = UIColor.red.cgColor
        textField.layer.addSublayer(bottomLine)
    }
    
    func getData(){
    
        let settings =  getSettings(.listOfElements)
        if settings.count != 0 {
            Salary.text = String(settings[0].value(forKeyPath: "salary") as! Int64)
            WorkLoad.text = String(settings[0].value(forKeyPath: "workLoad") as! Int64)
            if settings[0].value(forKeyPath: "luncheon") as! Bool == true {
                LuncheonSwitch.isOn = true
                LuncheonPrice.isHidden = false
                LuncheonPriceLabel.isHidden = false
                Currency.isHidden = false
                LuncheonPrice.text = String(settings[0].value(forKeyPath: "luncheonPrice") as! Int64)
            }
            Holiday.text = String(settings[0].value(forKeyPath: "holidayDays") as! Int64)
        }
    }
}
