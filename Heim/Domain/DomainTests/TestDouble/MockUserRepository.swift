//
//  MockUserRepository.swift
//  DomainTests
//
//  Created by 정지용 on 12/5/24.
//

@testable import Domain

final class MockUserRepository: UserRepository {
  struct CallCount {
    var fetchUserName = 0
    var updateUserName = 0
  }
  
  struct Return {
    var fetchUserName: String!
  }
  
  var callCount = CallCount()
  var returnValue = Return()
  
  func fetchUserName() async throws -> String {
    callCount.fetchUserName += 1
    return returnValue.fetchUserName
  }
  
  func updateUserName(to name: String) async throws {
    callCount.updateUserName += 1
    returnValue.fetchUserName = name
  }
}
