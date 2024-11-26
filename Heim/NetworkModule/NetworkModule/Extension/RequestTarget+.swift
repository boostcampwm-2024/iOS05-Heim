//
//  RequestTarget+.swift
//  NetworkModule
//
//  Created by 정지용 on 11/12/24.
//

import DataModule
import Domain
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
      if request.value(forHTTPHeaderField: "Content-Type") == "application/x-www-form-urlencoded" {
        request.setURLEncodedBody(body)
      } else {
        request.setBody(body)
      }
    }
    
    return request
  }
}
