//
//  SettingViewModelTests.swift
//  PresentationTests
//
//  Created by 박성근 on 12/5/24.
//

import XCTest
@testable import Presentation
import Domain

final class SettingViewModelTests: XCTestCase {
  private var sut: SettingViewModel!
  private var mockUseCase: MockSettingUseCase!
  
  override func setUp() {
    super.setUp()
    mockUseCase = MockSettingUseCase()
    sut = SettingViewModel(useCase: mockUseCase)
  }
  
  override func tearDown() {
    sut = nil
    mockUseCase = nil
    super.tearDown()
  }
  
  // MARK: - Initial State Tests
  func test_initialState() {
    XCTAssertEqual(sut.state.userName, "")
    XCTAssertFalse(sut.state.isConnectedCloud)
    XCTAssertFalse(sut.state.isErrorPresent)
  }
  
  // MARK: - Fetch User Name Tests
  func test_givenError_whenFetchUserName_thenSetsDefaultUserName() async throws {
    // Given
    mockUseCase.shouldThrowError = true
    
    // When
    sut.action(.fetchUserName)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    XCTAssertEqual(sut.state.userName, "User")
    XCTAssertEqual(mockUseCase.fetchUserNameCallCount, 1)
  }
  
  // MARK: - Update User Name Tests
  func test_givenValidName_whenUpdateUserName_thenUpdatesState() async throws {
    // Given
    let newName = "New User"
    
    // When
    sut.action(.updateUserName(newName))
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    XCTAssertEqual(sut.state.userName, newName)
    XCTAssertEqual(mockUseCase.updateUserNameCallCount, 1)
    XCTAssertFalse(sut.state.isErrorPresent)
  }
  
  func test_givenError_whenUpdateUserName_thenSetsErrorState() async throws {
    // Given
    mockUseCase.shouldThrowError = true
    
    // When
    sut.action(.updateUserName("New User"))
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    XCTAssertTrue(sut.state.isErrorPresent)
    XCTAssertEqual(mockUseCase.updateUserNameCallCount, 1)
  }
  
  // MARK: - Reset Data Tests
  func test_givenError_whenResetData_thenSetsErrorState() async throws {
    // Given
    mockUseCase.shouldThrowError = true
    
    // When
    sut.action(.resetData)
    
    // Then
    try await Task.sleep(nanoseconds: 100_000_000)
    XCTAssertTrue(sut.state.isErrorPresent)
    XCTAssertEqual(mockUseCase.resetDataCallCount, 1)
  }
  
  // MARK: - Clear Error Tests
  func test_whenClearError_thenResetsErrorState() {
    // Given
    sut.state.isErrorPresent = true
    
    // When
    sut.action(.clearError)
    
    // Then
    XCTAssertFalse(sut.state.isErrorPresent)
  }
}
