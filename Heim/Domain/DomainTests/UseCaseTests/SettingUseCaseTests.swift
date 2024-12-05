//
//  SettingUseCaseTests.swift
//  DomainTests
//
//  Created by 정지용 on 12/5/24.
//

import XCTest
@testable import Domain

final class SettingUseCaseTests: XCTestCase {
  var sut: SettingUseCase!
  var mockSettingRepository = MockSettingRepository()
  var mockUserRepository = MockUserRepository()
  
  override func setUp() {
    sut = DefaultSettingUseCase(
      settingRepository: mockSettingRepository,
      userRepository: mockUserRepository
    )
  }
  
  override func tearDown() {
    sut = nil
    mockSettingRepository = .init()
    mockUserRepository = .init()
  }
  
  func test_remove_cache_data_successfully_without_error() async throws {
    // Given
    
    // When
    try await sut.removeCacheData()
    
    // Then
    XCTAssert(true)
  }
  
  func test_reset_data_successfully_without_error() async throws {
    // Given
    
    // When
    try await sut.resetData()
    
    // Then
    XCTAssert(true)
  }
}
