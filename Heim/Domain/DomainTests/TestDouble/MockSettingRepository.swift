//
//  MockSettingRepository.swift
//  DomainTests
//
//  Created by 정지용 on 12/5/24.
//

@testable import Domain

final class MockSettingRepository: SettingRepository {
  struct CallCount {
    var removeCacheData = 0
    var resetData = 0
  }
  
  var callCount = CallCount()
  
  func removeCacheData() async throws {
    callCount.removeCacheData += 1
  }
  
  func resetData() async throws {
    callCount.resetData += 1
  }
}
