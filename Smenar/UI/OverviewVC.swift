//
//  OverviewVC.swift
//  Smenar
//
//  Created by Martin Berger on 29/04/2020.
//  Copyright © 2020 Martin Berger. All rights reserved.
//

import UIKit
import CoreData
import Foundation
import MHCoreData

class OverviewVC : UIViewController {
    
    @IBOutlet weak var ShiftDate: UILabel!
    @IBOutlet weak var ShiftStartTime: UILabel!
    @IBOutlet weak var ShiftEndTime: UILabel!
    @IBOutlet weak var ShiftType: UILabel!
    @IBOutlet weak var HourCounter: UILabel!
    @IBOutlet weak var DayCounter: UILabel!    
    @IBOutlet weak var Salary: UILabel!
    @IBOutlet weak var Luncheon: UILabel!
    @IBOutlet weak var LuncheonLabel: UILabel!
    @IBOutlet weak var LuncheonCurrency: UILabel!
    @IBOutlet weak var HolidayMonth: UILabel!
    @IBOutlet weak var HMDays: UILabel!
    @IBOutlet weak var HolidayRest: UILabel!
    @IBOutlet weak var HRDays: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        
        if UserDefaults.standard.bool(forKey: "Walkthrough") {
            super.viewWillAppear(animated)
            nextShiftData()
            workedData()
        }
        else {
            let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingsVC") as? SettingsVC
            self.navigationController?.pushViewController(vc!, animated: true)
        }
    }
    
    func nextShiftData(){
        
        let shifts = getData(.listOfElements, myStartDay: "\(day). \(month+1). \(year)", myEndDay: "", myPredicate: "(startDate >= %@) AND (typeOfShift <> %@)", predicateAdd: "D")
        
        if shifts.count != 0 {
            ShiftDate.text = dateFormat(inDate: (shifts[0].value(forKey: "startDate") as? Date)!)
            ShiftStartTime.text = timeFormat(inTime: (shifts[0].value(forKey: "startTime") as? Date)!)
            ShiftEndTime.text = timeFormat(inTime: (shifts[0].value(forKey: "endTime") as? Date)!)
            switch shifts[0].value(forKey: "typeOfShift") as? String {
            case "R":
                ShiftType.text = "Ranní"
            case "O":
                ShiftType.text = "Odpolední"
            case "N":
                ShiftType.text = "Noční"
            default:
                ShiftType.text = "Volno"
            }
            
        }
    }
    
    func workedData(){
        let shifts: [NSManagedObject] = getData(.listOfElements, myStartDay: "1. \(month+1). \(year)", myEndDay: "\(day). \(month+1). \(year)", myPredicate: "((startDate >= %@) AND (startDate < %@)) OR ((endDate < %@) AND (endDate >= %@))", predicateAdd: "endDate, startDate")
        
        var workedDays = shifts.count
        var holidayDays = 0
        var workedHours = 0.0
        if workedDays != 0 {
            for shift in shifts {
                var delta = 0.0
                if (shift.value(forKeyPath: "typeOfShift") as! String) == "D" {
                    workedDays -= 1
                    let startDay = dateFormat(inDate: shift.value(forKeyPath: "startDate") as! Date)
                    let sd = startDay.components(separatedBy: ". ")
                    let endDay = dateFormat(inDate: shift.value(forKeyPath: "endDate") as! Date)
                    let ed = endDay.components(separatedBy: ". ")
                    if (sd[1] == ed[1]) && (sd[2] == ed[2]){
                        holidayDays += (Int(ed[0])! - Int(sd[0])!) + 1
                    }
                    else if (Int(sd[1])! != Int(ed[1])!) && (sd[2] == ed[2]){
                        var NumOfDays = DaysInMonths[Int(sd[1])!-1]
                        if Int(sd[1])! == 2 {
                            if Int(sd[2])! % 4 == 0{
                                NumOfDays = 29
                            }
                        }
                        holidayDays +=  NumOfDays - Int(sd[0])! + 1
                    }
                }
                else {
                    delta = (shift.value(forKeyPath: "endTime") as! Date).timeIntervalSince(shift.value(forKeyPath: "startTime") as! Date)
                    delta = delta/3600
                    if (shift.value(forKeyPath: "startDate") as! Date) != (shift.value(forKeyPath: "endDate") as! Date) {
                        delta = 24 + delta
                    }
                    if delta > 6 {
                        workedHours += delta - 0.5
                    }
                    else {
                        workedHours += delta
                    }
                }
            }
        }
        
        DayCounter.text = String(workedDays)
        HourCounter.text = String(format: "%.2f", workedHours)
        HolidayMonth.text = String(holidayDays)
        switch Double(holidayDays) {
        case 1:
            HMDays.text = "den"
        case 2...4:
            HMDays.text = "dny"
        default:
            HMDays.text = "dnů"
        }
        
        let (hourSalary, luncheonPrice, holidaysDays, workLoad) = getSetting()
        
        Luncheon.text = String(workedDays * luncheonPrice)
        
        let passedHoliday = holidayData()
        let holidaySalary = (workLoad / 20 * hourSalary * holidayDays)
        Salary.text = String(format: "%.2f", (workedHours * Double(hourSalary)) + Double(holidaySalary))
        let holidayRest  = holidaysDays - passedHoliday
        HolidayRest.text = String(holidayRest)
        
        switch Double(holidayRest) {
        case 1:
            HRDays.text = "den"
        case 2...4:
            HRDays.text = "dny"
        default:
            HRDays.text = "dnů"
        }
        
    }
    
    func getSetting() -> (Int, Int, Int, Int){
    
        let settings = getSettings(.listOfElements)
        
        var hourSalary = 0
        var holidayDays = 0
        var luncheonPrice = 0
        var workLoad = 0
        
        if settings.count != 0 {
            hourSalary = Int(settings[0].value(forKeyPath: "salary") as! Double)
            workLoad = Int(settings[0].value(forKeyPath: "workLoad") as! Double)
            if settings[0].value(forKeyPath: "luncheon") as! Bool == true {
                Luncheon.isHidden = false
                LuncheonLabel.isHidden = false
                LuncheonCurrency.isHidden = false
                luncheonPrice = Int(settings[0].value(forKeyPath: "luncheonPrice") as! Double)
            }
            holidayDays = Int(settings[0].value(forKeyPath: "holidayDays") as! Double)
        }
        return (hourSalary, luncheonPrice, holidayDays, workLoad)
    }
    
    func holidayData() -> Int{
        let shifts = getData(.listOfElements, myStartDay: "1. 1. \(year)", myEndDay: "\(day). \(month+1). \(year)", myPredicate: "((((startDate >= %@) AND (startDate <= %@)) OR ((endDate >= %@) AND (endDate <= %@))) AND (typeOfShift == %@))", predicateAdd: "startDate, endDate, D")
        
        var holidayDays = 0
        
        for shift in shifts {
            let startDay = dateFormat(inDate: shift.value(forKeyPath: "startDate") as! Date)
            let sd = startDay.components(separatedBy: ". ")
            let endDay = dateFormat(inDate: shift.value(forKeyPath: "endDate") as! Date)
            let ed = endDay.components(separatedBy: ". ")
            let startDayInt = Int(sd[0])!
            let endDayInt = Int(ed[0])!
            let startMonth = Int(sd[1])!
            let endMonth = Int(ed[1])!
            let startYear = Int(sd[2])!
            let endYear = Int(ed[2])!
            var NumOfDays = DaysInMonths[startMonth-1]
            if (sd[2] == ed[2]) {
                if (sd[1] == ed[1]) {
                    holidayDays += (endDayInt - startDayInt) + 1
                }
                else if (startMonth - endMonth >= 1) {
                    if startMonth == 2 {
                        if startYear % 4 == 0{
                            NumOfDays = 29
                        }
                    }
                    holidayDays +=  NumOfDays - startDayInt
                    if (endMonth-1 > startMonth) {
                        for i in startMonth+1...endMonth-1 {
                            if i == 2 {
                                if startYear % 4 == 0{
                                    NumOfDays = 29
                                }
                            }
                            holidayDays += DaysInMonths[i-1]
                        }
                    }
                    holidayDays += endDayInt
                }
            }
            else if (startYear < endYear) {
                if endMonth == 1 {
                    holidayDays += endDayInt
                }
                else {
                    for i in 1...endMonth-1 {
                            if i == 2 {
                                if startYear % 4 == 0{
                                    NumOfDays = 29
                                }
                            }
                            holidayDays += DaysInMonths[i-1]
                    }
                    holidayDays += endDayInt
                }
            }
        }
        return holidayDays
    }
}
