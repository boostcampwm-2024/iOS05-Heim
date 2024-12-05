//
//  SettingRepositoryTests.swift
//  DataModuleTests
//
//  Created by 정지용 on 12/5/24.
//

import XCTest
@testable import DataModule
@testable import Domain

final class SettingRepositoryTests: XCTestCase {
  var sut: SettingRepository!
  var mockDataStorage = MockDataStorage()

  override func setUp() {
    sut = DefaultSettingRepository(localStorage: mockDataStorage)
  }
  
  override func tearDown() {
    sut = nil
    mockDataStorage = .init()
  }
  
  func test_remove_cache_successfully_without_error() async throws {
    // Given
    
    // When
    do {
      try await sut.removeCacheData()
      
      // Then
      XCTAssert(true)
    } catch {
      XCTFail("성공해야 하는 자리")
    }
  }
  
  func test_reset_data_successfully_without_error() async throws {
    // Given
    
    // When
    do {
      try await sut.resetData()
      
      // Then
      XCTAssert(true)
    } catch {
      XCTFail("성공해야 하는 자리")
    }
  }
}
