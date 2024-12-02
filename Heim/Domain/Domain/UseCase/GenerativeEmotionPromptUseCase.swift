//
//  GenerativeEmotionPromptUseCase.swift
//  Domain
//
//  Created by 박성근 on 11/28/24.
//

public protocol GenerativeEmotionPromptUseCase {
  func generate(_ input: String) async throws -> String?
}

public struct GeminiGenerativeEmotionPromptUseCase: GenerativeEmotionPromptUseCase, UserUseCase {
  public var userRepository: UserRepository
  var generativeRepository: GenerativeAIRepository
  var generator: PromptGenerator
  
  public init(
    userRepository: UserRepository,
    generativeRepository: GenerativeAIRepository,
    generator: PromptGenerator
  ) {
    self.userRepository = userRepository
    self.generativeRepository = generativeRepository
    self.generator = generator
  }
  
  public func generate(_ input: String) async throws -> String? {
    var username: String
    do {
      username = try await userRepository.fetchUserName()
    } catch {
      username = "User"
    }
    let prompt = try generator.generatePrompt(for: input, username: username)
    return try await generativeRepository.generateContent(for: prompt)
  }
}
