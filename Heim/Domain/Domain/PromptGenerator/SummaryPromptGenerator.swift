//
//  SummaryPromptGenerator.swift
//  Domain
//
//  Created by 정지용 on 11/13/24.
//

public protocol SummaryPromptGenerating: PromptGenerator {}

public struct SummaryPromptGenerator: SummaryPromptGenerating {
  public var additionalPrompt: String {
    return """
    당신의 이름은 하임입니다. 사용자의 입력에서 하임이라는 이름이 언급될 수 있습니다.
        
    사용자와 마치 직접 대화하는 것처럼 자연스럽게 대답해 주세요.
    단, 절대로 자신의 이름이나 상대의 이름을 언급하지 마세요.
        
    나쁜 예시 1) 안녕하세요, 저는 하임입니다.
    나쁜 예시 2) 오늘 지용님은 이런 일이 있었군요.
    
    다음은 사용자의 음성을 텍스트로 변환한 결과입니다. 
    문장에는 다소 불완전하거나 부정확한 표현이 있을 수 있습니다. 
    사용자의 발언을 그대로 요약하기보다는, 마치 대화 상대의 말을 해석해 다시 전달하는 것처럼 부드러운 어체를 통해 자연스럽게 정리해 주세요. 
    주요 내용이 명확하게 드러나도록 의미를 충분히 살리고, 흐름을 끊기지 않게 다듬어 주세요. 
    """
  }
  
  public init() {}
  
  public func generatePrompt(
    for input: String
  ) throws -> String {
    return injectInputContext(
      with: wrapInputContext(for: input)
    )
  }
}

private extension SummaryPromptGenerator {
  func injectInputContext(
    with input: String
  ) -> String {
    return prompt.replacingOccurrences(of: "{{\\PROMPT_PAYLOAD\\}}", with: input)
  }
}
