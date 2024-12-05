//
//  MockRequestTarget.swift
//  NetworkModule
//
//  Created by 김미래 on 12/5/24.
//

import DataModule

struct MockRequestTarget: RequestTarget {
  let baseURL: String
  let path: String
  let method: DataModule.HTTPMethod
  let headers: [String: String]
  let body: (any Encodable)?
  let query: [String: Any]
}

enum MockTarget {
  case get
  case post

  var request: MockRequestTarget {
    switch self {
    case .get:
      return MockRequestTarget(
        baseURL: "http://mock.example.com",
        path: "/v1/resource",
        method: .get,
        headers: [:],
        body: nil,
        query: ["mock": "test"]
    )
    case .post:
      return MockRequestTarget(
        baseURL: "http://mock.example.com",
        path: "/v1/resource",
        method: .get,
        headers: [:],
        body: nil,
        query: ["mock": "test"]
    )
    }
  }

}
