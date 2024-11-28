//
//  CalendarDate.swift
//  Domain
//
//  Created by 한상진 on 11/27/24.
//

public struct CalendarDate: Codable, Equatable {
  // MARK: - Properties
  public let year: Int
  public let month: Int
  public let day: Int
  public let hour: Int
  public let minute: Int
  public let second: Int
  
  // MARK: - Initializer
  public init(
    year: Int,
    month: Int,
    day: Int,
    hour: Int,
    minute: Int,
    second: Int
  ) {
    self.year = year
    self.month = month
    self.day = day
    self.hour = hour
    self.minute = minute
    self.second = second
  }
  
  // MARK: - Methods
  public func toTimeStamp() -> String {
    return [year, month, day, hour, minute, second].map { String($0) }.joined()
  }
}
