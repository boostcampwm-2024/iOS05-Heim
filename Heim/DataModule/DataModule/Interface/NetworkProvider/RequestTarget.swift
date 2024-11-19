//
//  RequestTarget.swift
//  DataModule
//
//  Created by 정지용 on 11/12/24.
//

public protocol RequestTarget {
  var baseURL: String { get }
  var path: String { get }
  var method: HTTPMethod { get }
  var headers: [String: String] { get }
  var body: Encodable? { get }
  var query: [String: Any] { get }
}
