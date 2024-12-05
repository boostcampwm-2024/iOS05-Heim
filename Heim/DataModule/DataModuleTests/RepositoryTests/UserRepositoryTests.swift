//
//  UserRepositoryTests.swift
//  DataModuleTests
//
//  Created by 정지용 on 12/5/24.
//

import XCTest
@testable import DataModule
@testable import Domain

final class UserRepositoryTests: XCTestCase {
  var sut: UserRepository!
  var mockDataStorage = MockDataStorage()

  override func setUp() {
    sut = DefaultUserRepository(dataStorage: mockDataStorage)
  }
  
  override func tearDown() {
    sut = nil
    mockDataStorage = .init()
  }
  
  func test_fetch_username_through_fetchUserName() async throws {
    // Given
    let input = "TEST"
    
    // When
    mockDataStorage.returnValue.readData = input
    let output = try await sut.fetchUsername()
    
    // Then
    XCTAssertEqual(output, input)
  }
  
  func test_update_username_successfully_without_error() async throws {
    // Given
    let input = "TEST"
    
    // When
    do {
      try await sut.updateUsername(to: input)
      
      // Then
      XCTAssert(true)
    } catch {
      XCTFail("성공해야 하는 자리")
    }
  }
}
