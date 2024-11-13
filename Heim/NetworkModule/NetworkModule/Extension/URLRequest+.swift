//
//  URLRequest+.swift
//  NetworkModule
//
//  Created by 정지용 on 11/12/24.
//

import Foundation

extension URLRequest {
  init(_ urlString: String, query: [String: Any]) throws {
    // TODO: NSError -> 다른 Error Type으로 변경
    guard var components = URLComponents(string: urlString) else { throw NSError() }
    components.queryItems = query.compactMap {
      URLQueryItem(name: $0.key, value: $0.value as? String)
    }
    
    guard let url = components.url else { throw NSError() }
    self.init(url: url)
  }
  
  mutating func setBody<T: Encodable>(_ body: T) {
    httpBody = try? JSONEncoder().encode(body)
  }
  
  mutating func makeURLHeaders(_ headers: [String: String]) {
    for header in headers {
      addValue(header.value, forHTTPHeaderField: header.key)
    }
  }
}
