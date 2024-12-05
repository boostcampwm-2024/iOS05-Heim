//
//  GenerativeAIRepository.swift
//  DomainTests
//
//  Created by 정지용 on 12/5/24.
//

@testable import Domain

final class MockGenerativeAIRepository: GenerativeAIRepository {
  struct CallCount {
    var generateContent = 0
  }
  
  struct Return {
    var generateContent: String!
  }
  
  var callCount = CallCount()
  var returnValue = Return()
  
  func generateContent(for content: String) async throws -> String? {
    callCount.generateContent += 1
    return content + returnValue.generateContent
  }
}
