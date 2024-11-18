//
//  RequestTarget+.swift
//  NetworkModule
//
//  Created by 정지용 on 11/12/24.
//

import DataModule
import Foundation

extension RequestTarget {
  var query: [String: Any] {
    return [:]
  }
  
  func makeURLRequest() throws -> URLRequest {
    var request: URLRequest = try URLRequest(baseURL + path, query: query)
    
    request.makeURLHeaders(headers)
    request.httpMethod = method.rawValue
    request.cachePolicy = .reloadIgnoringLocalCacheData
    
    if let body {
      request.setBody(body)
    }
    
    return request
  }
}
