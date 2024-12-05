//
//  MockDataStorage.swift
//  DataModuleTests
//
//  Created by 정지용 on 12/5/24.
//
// swiftlint:disable force_cast

@testable import DataModule
@testable import Domain

final class MockDataStorage: DataStorage {
  struct CallCount {
    var readData = 0
    var readDataWithTwoParameters = 0
    var readAll = 0
    var saveData = 0
    var saveDataWithThreeParameters = 0
    var deleteData = 0
    var deleteAll = 0
  }
  
  struct Return {
    var readData: Any!
    var readAll: Any!
  }
  
  var callCount = CallCount()
  var returnValue = Return()
  
  func readData<T>(directory: String, fileName: String) async throws -> T where T: Decodable {
    callCount.readDataWithTwoParameters += 1
    return returnValue.readData as! T
  }
  
  func readData<T>(calendarDate: CalendarDate) async throws -> T where T: Decodable {
    callCount.readData += 1
    return returnValue.readData as! T
  }
  
  func readAll<T>(directory: String) async throws -> T where T: Decodable {
    callCount.readAll += 1
    return returnValue.readAll as! T
  }
  
  func saveData<T>(directory: String, fileName: String, data: T) async throws where T: Encodable {
    callCount.saveDataWithThreeParameters += 1
  }
  
  func saveData<T>(calendarDate: CalendarDate, data: T) async throws where T: Encodable {
    callCount.saveData += 1
  }
  
  func deleteData(calendarDate: CalendarDate) async throws {
    callCount.deleteData += 1
  }
  
  func deleteAll() async throws {
    callCount.deleteAll += 1
  }
}
