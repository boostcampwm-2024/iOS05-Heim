//
//  SummaryPromptGenerator.swift
//  Domain
//
//  Created by 정지용 on 11/13/24.
//

public struct SummaryPromptGenerator: PromptGenerating {
  public var additionalPrompt: String {
    return """
    다음은 사용자의 음성을 텍스트로 변환한 결과입니다. 문장에는 다소 불완전하거나 부정확한 표현이 있을 수 있습니다. 사용자의 발언을 그대로 요약하기보다는, 마치 대화 상대의 말을 해석해 다시 전달하는 것처럼 부드러운 어체를 통해 자연스럽게 정리해 주세요. 주요 내용이 명확하게 드러나도록 의미를 충분히 살리고, 흐름을 끊기지 않게 다듬어 주세요. 
    """
  }
  
  public init() {}
  
  public func generatePrompt(for input: String) throws -> String {
    return injectInputContext(with: wrapInputContext(for: input))
  }
}
