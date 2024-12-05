//
//  UserUseCaseTests.swift
//  DomainTests
//
//  Created by 정지용 on 12/5/24.
//

import XCTest
@testable import Domain

final class UserUseCaseTests: XCTestCase {
  var sut: UserUseCase!
  var mockUserRepository = MockUserRepository()
  
  override func setUp() {
    sut = DefaultUserUseCase(userRepository: mockUserRepository)
  }
  
  override func tearDown() {
    sut = nil
    mockUserRepository = .init()
  }
  
  func test_fetch_username_through_fetchUserName() async throws {
    // Given
    let input = "fetchTests"
    mockUserRepository.returnValue.fetchUserName = input
    
    // When
    let output = try await sut.fetchUserName()
    
    // Then
    XCTAssertEqual(output, input)
  }
  
  func test_update_username_through_updateUserName() async throws {
    // Given
    let input = "updateTests"
    mockUserRepository.returnValue.fetchUserName = "default username"
    
    // When
    let updatedUsername = try await sut.updateUserName(to: input)
    let output = try await sut.fetchUserName()
    
    // Then
    XCTAssertEqual(updatedUsername, input)
    XCTAssertEqual(output, input)
  }
}
