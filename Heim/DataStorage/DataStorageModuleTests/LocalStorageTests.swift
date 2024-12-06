//
//  LocalStorageTests.swift
//  DataStorageModule
//
//  Created by 김미래 on 12/5/24.
//

import XCTest
@testable import DataStorageModule
@testable import Domain

final class LocalStorageTests: XCTestCase {

  // MARK: - Properties
  var localStorage: DefaultLocalStorage!
  struct MockData: Codable, Equatable {
    let name: String
    let age: Int
  }
  let mockData = MockData(name: "Heim", age: 12)

  // MARK: - TestCycle
  override func setUp() {
    super.setUp()

    localStorage = DefaultLocalStorage()
  }

  override func tearDown() {
    localStorage = nil

    super.tearDown()
  }

  func test_saveData_success() async throws {
    // given
    let mockCalendarDate = CalendarDate(year: 2024, month: 12, day: 25, hour: 12, minute: 25, second: 25)
    do {
      // when
      try await localStorage.saveData(calendarDate: mockCalendarDate,
                                      data: mockData)
    } catch(let error) {
      guard error is StorageError else {
        XCTFail("정의하지 않은 에러 발생")
        return
      }
      XCTFail("StorageError발생")
    }

    do {
      let result: [MockData] = try await localStorage.readData(calendarDate: mockCalendarDate)

      // Then
      XCTAssertEqual(result, [mockData])
    } catch(let error) {
      guard error is StorageError else {
        XCTFail("정의하지 않은 에러 발생")
        return
      }
      XCTFail("StorageError발생")
    }
  }

  func test_deleteAll_sucess() async throws {
    // given
    let mockCalendarDate1 = CalendarDate(year: 2024, month: 12, day: 25, hour: 12, minute: 25, second: 25)
    let mockCalendarDate2 = CalendarDate(year: 2024, month: 12, day: 26, hour: 12, minute: 23, second: 25)
    let mockCalendarDate3 = CalendarDate(year: 2024, month: 12, day: 27, hour: 12, minute: 25, second: 25)

    try await localStorage.saveData(calendarDate: mockCalendarDate1,
                                    data: mockData)
    try await localStorage.saveData(calendarDate: mockCalendarDate2,
                                    data: mockData)
    try await localStorage.saveData(calendarDate: mockCalendarDate3,
                                    data: mockData)

    // when
    try await localStorage.deleteAll()

    // then
    let result: [MockData] = try await localStorage.readAll(directory: "/Diary")
    XCTAssertEqual(result.count, 0)
  }

  func test_delete_success() async throws {
    // given
    let mockCalendarDate = CalendarDate(year: 2024, month: 12, day: 25, hour: 12, minute: 25, second: 25)
    try await localStorage.saveData(calendarDate: mockCalendarDate,
                                    data: mockData)

    // when
    try await localStorage.deleteData(calendarDate: mockCalendarDate)

    // then
    do {
      let result: [MockData] = try await localStorage.readData(calendarDate: mockCalendarDate)
      XCTAssertEqual(result.count, 0)
    } catch(let error) {
      guard let error = error as? StorageError else {
        XCTFail("StorageError가 아님")
        return
      }
      XCTAssertEqual(error, StorageError.readError)
    }
  }
}
