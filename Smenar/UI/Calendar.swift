//
//  Calendar.swift
//  Smenar
//
//  Created by Martin Berger on 12/04/2020.
//  Copyright © 2020 Martin Berger. All rights reserved.
//

import Foundation


let date = Date()
let calendar = Calendar.current

let day = calendar.component(.day, from: date)
var month = calendar.component(.month, from: date) - 1
var year = calendar.component(.year, from: date)

let myDate = getDate(inDate: "1. \(month+1). \(year)")

var weekday = calendar.component(.weekday, from: myDate!)

let monthC = calendar.component(.month, from: date) - 1
let yearC = calendar.component(.year, from: date)

var DaysInMonths = [31,28,31,30,31,30,31,31,30,31,30,31]

let Months = ["Leden","Únor","Březen","Duben","Květen","Červen","Červenec","Srpen","Září","Říjen","Listopad","Prosinec"]
    
func dateFormat(inDate: Date) -> String{
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    formatter.locale = NSLocale.init(localeIdentifier: "cs") as Locale
    return formatter.string(from: inDate)
}

func timeFormat(inTime: Date) -> String{
    let formatter = DateFormatter()
    formatter.dateStyle = .none
    formatter.timeStyle = .medium
    formatter.dateFormat = "H:mm"
    formatter.locale = NSLocale.init(localeIdentifier: "cs") as Locale
    return formatter.string(from: inTime)
}

func getDate(inDate: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd. MM. yyyy"
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = Locale.current
    return dateFormatter.date(from: inDate)
}

func getTime(inTime: String) -> Date? {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "HH:mm"
    dateFormatter.timeZone = TimeZone.current
    dateFormatter.locale = Locale.current
    return dateFormatter.date(from: inTime)
}

