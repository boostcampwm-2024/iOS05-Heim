//
//  GeminiAPI.swift
//  DataModule
//
//  Created by 정지용 on 11/13/24.
//

import Domain
import Foundation

enum GeminiAPI {
  case fetchGenerativeContent(content: String)
}

extension GeminiAPI: RequestTarget {
  var baseURL: String {
    return "\(GeminiEnvironment.baseURL)"
  }
  
  var path: String {
    switch self {
    case .fetchGenerativeContent:
      return "/v1beta/models/\(GeminiEnvironment.model)"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .fetchGenerativeContent:
      return .post
    }
  }
  
  var headers: [String: String] {
    switch self {
    case .fetchGenerativeContent:
      return [
        "Content-Type": "application/json"
      ]
    }
  }
  
  var body: (any Encodable)? {
    switch self {
    case .fetchGenerativeContent(let content):
      return GeminiGenerateRequestDTO(
        contents: [RequestContent(
          role: "user",
          parts: [RequestPart(text: content)]
        )],
        generationConfig: GenerationConfig(
          temparature: 0.8,
          topK: 50,
          topP: 0.85,
          maxOutputTokens: 8192,
          responseMimeType: "text/plain"
        )
      )
    }
  }
  
  var query: [String: Any] {
    switch self {
    case .fetchGenerativeContent:
      return [
        "key": GeminiEnvironment.apiKey
      ]
    }
  }
}
