//
//  MockRequestTarget.swift
//  DataModuleTests
//
//  Created by 정지용 on 12/5/24.
//

import Foundation
@testable import DataModule

final class MockRequestTarget: RequestTarget {
  var baseURL: String
  var path: String
  var method: HTTPMethod
  var headers: [String: String]
  var body: (any Encodable)?
  var query: [String: Any]
  
  init(
    baseURL: String,
    path: String,
    method: HTTPMethod,
    headers: [String: String],
    body: (any Encodable)? = nil,
    query: [String: Any]
  ) {
    self.baseURL = baseURL
    self.path = path
    self.method = method
    self.headers = headers
    self.body = body
    self.query = query
  }
}
