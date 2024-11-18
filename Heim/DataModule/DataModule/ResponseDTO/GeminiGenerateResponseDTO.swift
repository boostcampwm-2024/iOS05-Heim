//
//  GeminiGenerateResponseDTO.swift
//  DataModule
//
//  Created by 정지용 on 11/14/24.
//

struct GeminiGenerateResponseDTO: Decodable {
  let candidates: [Candidate]
  let usageMetadata: UsageMetadata
  let modelVersion: String
  
  var content: String? {
    return candidates.first?.text
  }
}

struct Candidate: Decodable {
  let content: ResponseContent
  let finishReason: String
  
  fileprivate var text: String? {
    return content.text
  }
}

struct ResponseContent: Decodable {
  let parts: [ResponsePart]
  let role: String
  
  fileprivate var text: String? {
    return parts.first?.text
  }
}

struct ResponsePart: Decodable {
  let text: String
}

struct UsageMetadata: Decodable {
  let promptTokenCount: Int
  let candidatesTokenCount: Int
  let totalTokenCount: Int
}
