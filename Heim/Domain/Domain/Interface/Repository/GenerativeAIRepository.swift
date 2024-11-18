//
//  GenerativeAIRepository.swift
//  Domain
//
//  Created by 정지용 on 11/13/24.
//

public protocol GenerativeAIRepository {
  func generateContent(for content: String) async throws -> String?
}
