//
//  MockSettingUseCase.swift
//  Presentation
//
//  Created by 박성근 on 12/5/24.
//

import Foundation
import Domain
@testable import Presentation

class MockSettingUseCase: SettingUseCase {
  var settingRepository: SettingRepository {
    fatalError("Not implemented")
  }
  
  var userRepository: UserRepository {
    fatalError("Not implemented")
  }
  
  var fetchUserNameCallCount = 0
  var updateUserNameCallCount = 0
  var isConnectedCloudCallCount = 0
  var updateCloudStateCallCount = 0
  var removeCacheDataCallCount = 0
  var resetDataCallCount = 0
  
  var mockUserName = "TestUser"
  var mockIsConnectedCloud = true
  var shouldThrowError = false
  
  enum MockError: Error {
    case testError
  }
  
  func fetchUserName() async throws -> String {
    fetchUserNameCallCount += 1
    if shouldThrowError {
      throw MockError.testError
    }
    return mockUserName
  }
  
  func updateUserName(to name: String) async throws -> String {
    updateUserNameCallCount += 1
    if shouldThrowError {
      throw MockError.testError
    }
    mockUserName = name
    return name
  }
  
  func isConnectedCloud() async throws -> Bool {
    isConnectedCloudCallCount += 1
    if shouldThrowError {
      throw MockError.testError
    }
    return mockIsConnectedCloud
  }
  
  func updateCloudState(isConnected: Bool) async throws {
    updateCloudStateCallCount += 1
    if shouldThrowError {
      throw MockError.testError
    }
    mockIsConnectedCloud = isConnected
  }
  
  func removeCacheData() async throws {
    removeCacheDataCallCount += 1
    if shouldThrowError {
      throw MockError.testError
    }
  }
  
  func resetData() async throws {
    resetDataCallCount += 1
    if shouldThrowError {
      throw MockError.testError
    }
  }
}
