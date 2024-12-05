//
//  MockUserUseCase.swift
//  Presentation
//
//  Created by 박성근 on 12/6/24.
//

import Foundation
import Domain
@testable import Presentation

final class MockUserUseCase: UserUseCase {
  var userRepository: UserRepository {
    fatalError("Not implemented")
  }
  
  var fetchUserNameCallCount = 0
  var mockUserName = "TestUser"
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
  
  func updateUserName(to name: String) async throws -> String { name }
}
