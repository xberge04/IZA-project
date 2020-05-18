//
//  CalendarVC.swift
//  Smenar
//
//  Created by Martin Berger on 19/04/2020.
//  Copyright © 2020 Martin Berger. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import MHCoreData

class DataCollectionViewCell1: UICollectionViewCell {
    
    
    @IBOutlet weak var DataLabel: UILabel!
}

class CalendarVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var Calendar: UICollectionView!
    
    @IBOutlet weak var MonthLabel: UILabel!
    
    let DaysOfWeek = ["Pondělí","Úterý","Středa","Čtvrtek","Pátek","Sobota","Neděle"]
    
    var currentMonth = String()
    
    var NumberOfEmptyBox = Int()
 
    var NextNumberOfEmptyBox = Int()
    
    var PreviousNumberOfEmptyBox = 0
    
    var Direction = 0
    
    var PositionIndex = 0
    
    override func viewWillAppear(_ animated: Bool) {
        Calendar.reloadData()
        super.viewWillAppear(animated) // No need for semicolon
        
        currentMonth = Months[month]

        GetStartDateDayPosition()
        
        MonthLabel.text = "\(currentMonth) \(year)"
    }
    
    @IBAction func Back(_ sender: Any) {
        switch currentMonth {
        case "Leden":
            month = 11
            year -= 1
            Direction = -1
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
            
        default:
            month -= 1
            Direction = -1
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        }
    }
    
    @IBAction func Next(_ sender: Any) {
        switch currentMonth {
        case "Prosinec":
            month = 0
            year += 1
            Direction = 1
            
            GetStartDateDayPosition()
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
            
        default:
            Direction = 1
            
            GetStartDateDayPosition()
            
            month += 1
            
            currentMonth = Months[month]
            MonthLabel.text = "\(currentMonth) \(year)"
            Calendar.reloadData()
        }
    }
    
    func GetStartDateDayPosition() {
            
        var NumOfDays = DaysInMonths[month]
        if Months[month] == "Únor" {
            if year % 4 == 0{
                NumOfDays = 29
            }
        }
        
        
        switch Direction {
        case 0:
            if weekday == 1 {
                weekday = 8
            }
            NumberOfEmptyBox = weekday - 2
            PositionIndex = NumberOfEmptyBox
            
        case 1...:
            NextNumberOfEmptyBox = (PositionIndex + NumOfDays)%7
            PositionIndex = NextNumberOfEmptyBox
            
        case -1:
            PreviousNumberOfEmptyBox = (7 - (NumOfDays - PositionIndex)%7)
            if PreviousNumberOfEmptyBox == 7 {
                PreviousNumberOfEmptyBox = 0
            }
            PositionIndex = PreviousNumberOfEmptyBox
        
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var NumOfDays = DaysInMonths[month]
        if Months[month] == "Únor" {
            if year % 4 == 0{
                NumOfDays = 29
            }
        }
        
        switch Direction {
        case 0:
            return NumOfDays + NumberOfEmptyBox
            
        case 1...:
            return NumOfDays + NextNumberOfEmptyBox
            
        case -1:
            return NumOfDays + PreviousNumberOfEmptyBox
        
        default:
            fatalError()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Calendar", for: indexPath) as! DataCollectionViewCell1
        cell.backgroundColor = UIColor.clear
        if cell.isHidden{
            cell.isHidden = false
        }
        
        cell.DataLabel.textColor = UIColor.white
        
        switch Direction {
        case 0:
            cell.DataLabel.text = "\(indexPath.row + 1 - NumberOfEmptyBox)"
         
        case 1...:
            cell.DataLabel.text = "\(indexPath.row + 1 - NextNumberOfEmptyBox)"
            
        case -1:
            cell.DataLabel.text = "\(indexPath.row + 1 - PreviousNumberOfEmptyBox)"
            
        default:
            fatalError()
        }
        
        if Int(cell.DataLabel.text!)! < 1 {
            cell.isHidden = true
        }
                
        switch indexPath.row {
        case 5,6,12,13,19,20,26,27,33,34:
            if Int(cell.DataLabel.text!)! > 0 {
                cell.DataLabel.textColor = UIColor.lightGray
            }
        default:
            break
        }
        
        if currentMonth == Months[monthC]{
            if Int(cell.DataLabel.text!)! == day{
                if year == yearC {
                    cell.DataLabel.textColor = UIColor.red
                }
            }
        }
        
        let(day, month, Year, shiftType) = getMyData()
        
        if day.count > 0 {
            for n in 0...(day.count-1){
                if currentMonth == Months[month[n]-1]{
                    if Int(cell.DataLabel.text!)! == day[n]{
                        if year == Year[n] {
                            if shiftType[n] == "R"{
                                cell.backgroundColor = UIColor.init(red: 33/255, green: 254/255, blue: 128/255, alpha: 1.0)
                                cell.DataLabel.textColor = UIColor.init(red: 1/255, green: 0/255, blue: 30/255, alpha: 1.0)
                            }
                                
                            else if shiftType[n] == "O"{
                                cell.backgroundColor = UIColor.red
                                cell.DataLabel.textColor = UIColor.init(red: 1/255, green: 0/255, blue: 30/255, alpha: 1.0)
                            }
                                
                            else if shiftType[n] == "N"{
                                cell.backgroundColor = UIColor.yellow
                                cell.DataLabel.textColor = UIColor.init(red: 1/255, green: 0/255, blue: 30/255, alpha: 1.0)
                            }
                            else if shiftType[n] == "D"{
                                cell.backgroundColor = UIColor.orange
                                cell.DataLabel.textColor = UIColor.init(red: 1/255, green: 0/255, blue: 30/255, alpha: 1.0)
                            }

                        }
                    }
                }
            }
        }
        
        cell.clipsToBounds = true
        cell.layer.cornerRadius = cell.frame.size.width/2
        cell.DataLabel.textAlignment = .center
        
        return cell
    }
    
    func getMyData() -> (Array<Int>, Array<Int>, Array<Int>, Array<String>){
        
        let shifts = getData(.listOfElements, myStartDay: "1. 1. 2000", myEndDay: "", myPredicate: "", predicateAdd: "")
        
        var day = [Int]()
        var month = [Int]()
        var year = [Int]()
        var shiftType = [String]()
        
        for shift in shifts {
            var sd = String()
            sd = dateFormat(inDate: shift.value(forKeyPath: "startDate") as! Date)
            let sdArr = sd.components(separatedBy: ". ")
            day.append(Int(String(sdArr[0]) as String)!)
            month.append(Int(String(sdArr[1]) as String)!)
            year.append(Int(String(sdArr[2]) as String)!)
            shiftType.append(shift.value(forKeyPath: "typeOfShift") as! String)
            if shift.value(forKeyPath: "typeOfShift") as! String == "D"
            {
                var ed = String()
                ed = dateFormat(inDate: shift.value(forKeyPath: "endDate") as! Date)
                let edArr = ed.components(separatedBy: ". ")
                if Int(String(sdArr[1]) as String)! == Int(String(edArr[1]) as String)! {
                    for x in (Int(String(sdArr[0]) as String)!+1...Int(String(edArr[0]) as String)!)
                    {
                        day.append(x)
                        month.append(Int(String(sdArr[1]) as String)!)
                        year.append(Int(String(sdArr[2]) as String)!)
                        shiftType.append(shift.value(forKeyPath: "typeOfShift") as! String)
                    }
                }
                else {
                    for x in (Int(String(sdArr[0]) as String)!+1...DaysInMonths[Int(String(sdArr[1]) as String)!-1])
                    {
                        day.append(x)
                        month.append(Int(String(sdArr[1]) as String)!)
                        year.append(Int(String(sdArr[2]) as String)!)
                        shiftType.append(shift.value(forKeyPath: "typeOfShift") as! String)
                    }
                    for x in (1...Int(String(edArr[0]) as String)!)
                    {
                        day.append(x)
                        month.append(Int(String(edArr[1]) as String)!)
                        year.append(Int(String(edArr[2]) as String)!)
                        shiftType.append(shift.value(forKeyPath: "typeOfShift") as! String)
                    }
                }
            }
        }
        return ( day, month, year, shiftType)
    }
}
