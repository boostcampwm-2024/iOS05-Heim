//
//  GenerativeAIUseCase.swift
//  Domain
//
//  Created by 박성근 on 11/28/24.
//

public protocol GenerativeSummaryPromptUseCase {
  func generate(_ input: String) async throws -> String?
}

public struct GeminiGenerativeSummaryPromptUseCase: GenerativeSummaryPromptUseCase {
  var repository: GenerativeAIRepository
  var generator: PromptGenerating
  
  public init(
    repository: GenerativeAIRepository,
    generator: PromptGenerating
  ) {
    self.repository = repository
    self.generator = generator
  }
  
  public func generate(_ input: String) async throws -> String? {
    let prompt = try generator.generatePrompt(for: input)
    return try await repository.generateContent(for: prompt)
  }
}
