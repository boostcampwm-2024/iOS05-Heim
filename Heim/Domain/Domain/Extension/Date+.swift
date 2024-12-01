//
//  Date+.swift
//  Presentation
//
//  Created by 한상진 on 11/27/24.
//

import Foundation

public extension Date {
  func calendarDate() -> CalendarDate {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self)
    
    let year = components.year ?? 0
    let month = components.month ?? 0
    let day = components.day ?? 0
    let hour = components.hour ?? 0
    let minute = components.minute ?? 0
    let second = components.second ?? 0
    
    return CalendarDate(year: year, month: month, day: day, hour: hour, minute: minute, second: second)
  }
}
