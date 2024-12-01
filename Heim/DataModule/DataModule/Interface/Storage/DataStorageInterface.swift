//
//  DataStorage.swift
//  DataModule
//
//  Created by 박성근 on 11/20/24.
//

import Domain
import Foundation

public protocol DataStorage {
  func readData<T: Decodable>(directory: String, fileName: String) async throws -> T
  func readData<T: Decodable>(calendarDate: CalendarDate) async throws -> T
  func readAll<T: Decodable>(directory: String) async throws -> T
  func saveData<T: Encodable>(directory: String, fileName: String, data: T) async throws
  func saveData<T: Encodable>(calendarDate: CalendarDate, data: T) async throws
  func deleteData(calendarDate: CalendarDate) async throws
  func deleteAll() async throws
}
