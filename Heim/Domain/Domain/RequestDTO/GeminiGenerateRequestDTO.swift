//
//  GeminiRequestDTO.swift
//  Domain
//
//  Created by 정지용 on 11/14/24.
//

import Foundation

public struct GeminiGenerateRequestDTO: Encodable {
  public let contents: [RequestContent]
  public let generationConfig: GenerationConfig
  
  public init(
    contents: [RequestContent],
    generationConfig: GenerationConfig
  ) {
    self.contents = contents
    self.generationConfig = generationConfig
  }
}

public struct RequestContent: Encodable {
  public let role: String
  public let parts: [RequestPart]
  
  public init(role: String, parts: [RequestPart]) {
    self.role = role
    self.parts = parts
  }
}

public struct RequestPart: Encodable {
  public let text: String
  
  public init(text: String) {
    self.text = text
  }
}

public struct GenerationConfig: Encodable {
  public let temperature: Double
  public let topK: Int
  public let topP: Double
  public let maxOutputTokens: Int
  public let responseMimeType: String
  
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
