//
//  InitializeData. swift
//  Smenar
//
//  Created by Martin Berger on 18/05/2020.
//  Copyright © 2020 Martin Berger.  All rights reserved.
//

import Foundation

func initData() {
    let sd = ["24. 04. 2020", "27. 04. 2020", "28. 04. 2020", "01. 05. 2020", "04. 05. 2020", "12. 05. 2020", "13. 05. 2020", "16. 05. 2020", "17. 05. 2020", "18. 05. 2020", "21. 05. 2020", "23. 05. 2020", "24. 05. 2020", "25. 05. 2020", "28. 05. 2020", "29. 05. 2020", "30. 05. 2020", "01. 06. 2020", "03. 06. 2020", "04. 06. 2020", "07. 06. 2020", "08. 06. 2020", "09. 06. 2020", "12. 06. 2020", "13. 06. 2020"]
    let ed = ["24. 04. 2020", "27. 04. 2020", "28. 04. 2020", "02. 05. 2020", "08. 05. 2020", "12. 05. 2020", "13. 05. 2020", "16. 05. 2020", "17. 05. 2020", "18. 05. 2020", "21. 05. 2020", "23. 05. 2020", "24. 05. 2020", "25. 05. 2020", "29. 05. 2020", "30. 05. 2020", "31. 05. 2020", "01. 06. 2020", "03. 06. 2020", "04. 06. 2020", "07. 06. 2020", "09. 06. 2020", "10. 06. 2020", "12. 06. 2020", "13. 06. 2020"]
    let st = ["05:15", "13:30", "13:30", "21:45", "00:00", "05:15", "13:30", "05:15", "13:30", "13:30", "05:15", "05:15", "05:15", "05:15", "21:45", "21:45", "21:45", "13:30", "13:30", "13:30", "05:15", "21:45", "21:45", "13:30", "13:30"]
    let et = ["13:45", "22:00", "22:00", "06:15", "00:00", "13:45", "22:00", "13:45", "22:00", "22:00", "13:45", "13:45", "13:45", "13:45", "06:15", "06:15", "06:15", "22:00", "22:00", "22:00", "13:45", "06:15", "06:15", "22:00", "22:00"]
    let ts = ["R", "O", "O", "N", "D", "R", "O", "R", "O", "O", "R", "R", "R", "R", "N", "N", "N", "O", "O", "O", "R", "N", "N", "O", "O"]
    for i in 0...sd.count-1 {
        let newShift = MOC().allocShift()
        newShift.startDate = getDate(inDate: sd[i])
        newShift.endDate = getDate(inDate: ed[i])
        newShift.startTime = getTime(inTime: st[i])
        newShift.endTime = getTime(inTime: et[i])
        newShift.typeOfShift = ts[i]
        APP().saveContext()
    }
}
