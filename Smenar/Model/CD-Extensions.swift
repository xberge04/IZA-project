//
//  CD-Extensions.swift
//  Smenar
//
//  Created by Martin Berger on 26/04/2020.
//  Copyright © 2020 Martin Berger. All rights reserved.
//


import Foundation
import CoreData
import UIKit
import MHCoreData


extension Identification {
    
    convenience init(initialized context: NSManagedObjectContext) {
        
        self.init(context: context)
        
        
        self.dateCreated = Date()
        self.idCode = UUID().uuidString
    }
}

let morning = UIImage(named: "R_ICON")
let afternoon = UIImage(named: "O_ICON")
let night = UIImage(named: "N_ICON")
let holiday = UIImage(named: "D_ICON")

extension Shift : MHFetchable {
    public static var frcBasicKey: AttributeName { "startDate" }
}

extension MySettings : MHFetchable {
    public static var frcBasicKey: AttributeName { "salary" }
}

func getData(_ purpose: MHTablePurpose, myStartDay: String, myEndDay: String, myPredicate: String, predicateAdd: String) -> [NSManagedObject]{

    var shifts: [NSManagedObject] = []
    
    guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
            return shifts
      }
      
    let managedContext = appDelegate.persistentContainer.viewContext
      
    let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Shift")
      
    let startDate:NSDate = getDate(inDate: myStartDay)! as NSDate
    
    if myPredicate != "" {
        if myEndDay == "" {
            if predicateAdd == "" {
                fetchRequest.predicate = NSPredicate(format: myPredicate, startDate)
            }
            else {
                fetchRequest.predicate = NSPredicate(format: myPredicate, startDate, predicateAdd)
            }
        }
        else {
            if predicateAdd == "" {
                let endDate:NSDate = getDate(inDate: myEndDay)! as NSDate
                fetchRequest.predicate = NSPredicate(format: myPredicate, startDate, endDate)
            }
            else {
                if predicateAdd[predicateAdd.startIndex..<predicateAdd.endIndex] == "endDate, startDate" {
                    let endDate:NSDate = getDate(inDate: myEndDay)! as NSDate
                    fetchRequest.predicate = NSPredicate(format: myPredicate, startDate, endDate, endDate, startDate)
                }
                else if predicateAdd.count == 1{
                    let endDate:NSDate = getDate(inDate: myEndDay)! as NSDate
                    fetchRequest.predicate = NSPredicate(format: myPredicate, startDate, endDate, predicateAdd)
                }
                else {
                    let endDate:NSDate = getDate(inDate: myEndDay)! as NSDate
                    let suffix = String(predicateAdd.suffix(1)) as String
                    fetchRequest.predicate = NSPredicate(format: myPredicate, startDate, endDate,  endDate, startDate, suffix)
                }
            }
        }
    }
    
    fetchRequest.sortDescriptors = [NSSortDescriptor(key: "startDate", ascending: true)]
    
    do {
        shifts = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
    }
    return shifts
}

func getSettings(_ purpose: MHTablePurpose) -> [NSManagedObject]{

    var settings: [NSManagedObject] = []
    
    guard let appDelegate =
      UIApplication.shared.delegate as? AppDelegate else {
        return settings
    }
    
    let managedContext =
      appDelegate.persistentContainer.viewContext
    
    let fetchRequest =
      NSFetchRequest<NSManagedObject>(entityName: "MySettings")
    
    
    do {
      settings = try managedContext.fetch(fetchRequest)
    } catch let error as NSError {
      print("Could not fetch. \(error), \(error.userInfo)")
    }
    
    return settings
}
