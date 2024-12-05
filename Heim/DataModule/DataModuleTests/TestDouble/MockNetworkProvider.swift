//
//  MockNetworkProvider.swift
//  DataModuleTests
//
//  Created by 정지용 on 12/5/24.
//
// swiftlint:disable force_cast

import Foundation
@testable import DataModule

final class MockNetworkProvider: NetworkProvider {
  struct CallCount {
    var request = 0
    var makeURL = 0
  }
  
  struct Return {
    var request: Any!
    var makeURL: URL!
  }
  
  var callCount = CallCount()
  var returnValue = Return()
  
  func request<T>(target: any DataModule.RequestTarget, type: T.Type) async throws -> T where T: Decodable {
    callCount.request += 1
    return returnValue.request as! T
  }
  
  func makeURL(target: any DataModule.RequestTarget) throws -> URL? {
    callCount.makeURL += 1
    return returnValue.makeURL
  }
}
