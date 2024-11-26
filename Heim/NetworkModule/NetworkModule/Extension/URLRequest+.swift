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
      URLQueryItem(
        name: $0.key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? $0.key,
        value: ($0.value as? String)?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
      )
    }
    
    guard let url = components.url else { throw NSError() }
    self.init(url: url)
  }
  
  mutating func setBody<T: Encodable>(_ body: T) {
    httpBody = try? JSONEncoder().encode(body)
  }
  
  mutating func setURLEncodedBody<T: Encodable>(_ body: T) {
    guard let dictionary = try? JSONSerialization.jsonObject(with: JSONEncoder().encode(body)) as? [String: Any] else {
      return
    }
    let urlEncodedString = dictionary
      .compactMap { key, value -> String in
        let escapedKey = key.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        return "\(escapedKey)=\(escapedValue)"
      }
      .joined(separator: "&")
    
    self.httpBody = urlEncodedString.data(using: .utf8)
  }
  
  mutating func makeURLHeaders(_ headers: [String: String]) {
    for header in headers {
      addValue(header.value, forHTTPHeaderField: header.key)
    }
  }
}
