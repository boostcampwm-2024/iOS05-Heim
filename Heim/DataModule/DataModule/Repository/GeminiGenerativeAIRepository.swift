//
//  GeminiGenerativeAIRepository.swift
//  DataModule
//
//  Created by 정지용 on 11/13/24.
//

import Domain

public final class GeminiGenerativeAIRepository: GenerativeAIRepository {
  private let networkProvider: NetworkProvider
  
  public init(networkProvider: NetworkProvider) {
    self.networkProvider = networkProvider
  }
  
  public func generateContent(for content: String) async throws -> String? {
    let response = try await networkProvider.request(
      target: GeminiAPI.fetchGenerativeContent(content: content),
      type: GeminiGenerateResponseDTO.self
    )
    
    return response.content
  }
}
