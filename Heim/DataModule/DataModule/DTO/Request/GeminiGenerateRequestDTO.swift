//
//  GeminiRequestDTO.swift
//  Domain
//
//  Created by 정지용 on 11/14/24.
//

import Foundation

public struct GeminiGenerateRequestDTO: Encodable {
  private let contents: [RequestContent]
  private let generationConfig: GenerationConfig
  
  init(
    contents: [RequestContent],
    generationConfig: GenerationConfig
  ) {
    self.contents = contents
    self.generationConfig = generationConfig
  }
}

public struct RequestContent: Encodable {
  private let role: String
  private let parts: [RequestPart]
  
  init(role: String, parts: [RequestPart]) {
    self.role = role
    self.parts = parts
  }
}

public struct RequestPart: Encodable {
  private let text: String
  
  init(text: String) {
    self.text = text
  }
}

public struct GenerationConfig: Encodable {
  private let temperature: Double
  private let topK: Int
  private let topP: Double
  private let maxOutputTokens: Int
  private let responseMimeType: String
  
  public init(
    temparature: Double,
    topK: Int,
    topP: Double,
    maxOutputTokens: Int,
    responseMimeType: String
  ) {
    self.temperature = temparature
    self.topK = topK
    self.topP = topP
    self.maxOutputTokens = maxOutputTokens
    self.responseMimeType = responseMimeType
  }
}
