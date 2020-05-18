//
//  GlobalCDModel.swift
//  Smenar
//
//  Created by Martin Berger on 24/04/2020.
//  Copyright © 2020 Martin Berger. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension NSManagedObjectContext {
    
    func  allocShift() -> Shift{
        let _shift = Shift(context: self)
        
        _shift.startTime = Date()
        _shift.startDate = Date()
        _shift.endDate = Date()
        _shift.endTime = Date()
        _shift.typeOfShift = "R"
        
        return _shift
    }
    
    func  allocSettings() -> MySettings{
        let _settings = MySettings(context: self)
        
        _settings.salary = 0
        _settings.luncheon = false
        _settings.luncheonPrice = 0
        _settings.workLoad = 0
        
        return _settings
    }
}
