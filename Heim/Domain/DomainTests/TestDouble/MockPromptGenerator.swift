//
//  MockPromptGenerator.swift
//  DomainTests
//
//  Created by 정지용 on 12/5/24.
//

@testable import Domain

final class MockPromptGenerator: PromptGenerator {
  struct CallCount {
    var generatePrompt = 0
  }
  
  struct Return {
    var generatePrompt: String!
  }
  
  var callCount = CallCount()
  var returnValue = Return()
  var additionalPrompt: String = ""
  
  func generatePrompt(for input: String) throws -> String {
    callCount.generatePrompt += 1
    return input + returnValue.generatePrompt
  }
}
