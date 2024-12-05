//
//  GenerativeAIUseCase.swift
//  Domain
//
//  Created by 박성근 on 11/28/24.
//

public protocol GenerativeSummaryUseCase {
  func generate(_ input: String) async throws -> String?
}

public struct GeminiGenerativeSummaryUseCase: GenerativeSummaryUseCase {
  var generativeRepository: GenerativeAIRepository
  var generator: PromptGenerator
  
  public init(
    generativeRepository: GenerativeAIRepository,
    generator: PromptGenerator
  ) {
    self.generativeRepository = generativeRepository
    self.generator = generator
  }
  
  public func generate(_ input: String) async throws -> String? {
    let prompt = try generator.generatePrompt(for: input)
    return try await generativeRepository.generateContent(for: prompt)
  }
}
