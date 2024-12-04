//
//  EmotionPromptGenerator.swift
//  Domain
//
//  Created by 정지용 on 11/13/24.
//

import Foundation

public protocol EmotionPromptGenerating: PromptGenerator {}

public struct EmotionPromptGenerator: EmotionPromptGenerating {
  public var additionalPrompt: String {
    return """
    마치 직접 대화하는 것처럼 자연스럽게 대답해 주세요.
    """
  }
  
  public init() {}
  
  public func generatePrompt(
    for input: String
  ) throws -> String {
    let emotion = Emotion(rawValue: input) ?? Emotion.none
    return injectInputContext(
      with: try emotion.emotionPrompt
    )
  }
}

private extension EmotionPromptGenerator {
  func injectInputContext(
    with input: String
  ) -> String {
    return prompt.replacingOccurrences(of: "{{\\PROMPT_PAYLOAD\\}}", with: input)
  }
}

private extension Emotion {
  var emotionPrompt: String {
    get throws {
      switch self {
      case .angry:
        return """
        사용자는 지금 분노를 느끼고 있습니다. 분노는 순간적으로 우리를 압도할 수 있는 감정입니다. 
        이 감정을 가라앉히고 평온을 되찾을 수 있도록, 심호흡을 통해 긴장을 풀고 스스로를 진정시킬 수 있는 방법에 대해 조언해 주세요. 
        또한, 차분하게 현재 상황을 바라볼 수 있는 구체적인 방법을 제공하세요.
        """
      case .happiness:
        return """
        사용자는 지금 행복을 느끼고 있습니다. 행복은 삶의 순간을 빛나게 하는 중요한 감정입니다. 
        이 행복한 순간이 지속될 수 있도록, 긍정적인 마음을 유지하며 더 나은 미래를 그릴 수 있는 영감을 제공하세요. 
        또한, 주변 사람들과 행복을 나누며 더욱 기쁜 순간을 만들어갈 수 있는 방법을 안내하세요.
        """
      case .sadness:
        return """
        사용자는 지금 슬픔을 느끼고 있습니다. 슬픔은 우리의 마음을 무겁게 할 수 있는 감정이지만, 
        이 감정을 통해 성장할 수 있는 기회를 찾을 수도 있습니다. 스스로를 위로하고, 마음을 다스릴 수 있는 방법과 
        현재 상황에서 힘을 얻을 수 있는 긍정적인 관점을 제시하세요. 또한, 작은 즐거움을 찾을 수 있는 일상적인 팁을 제공하세요.
        """
      case .surprise:
        return """
        사용자는 지금 당황스러워 하고 있습니다. 혼란은 결정을 내리거나 상황을 명확히 이해하지 못할 때 생길 수 있습니다. 
        사용자가 혼란을 해결할 수 있도록, 현재 상황을 단계적으로 정리하고 명확히 바라볼 수 있는 조언을 제공하세요. 
        또한, 복잡한 문제를 해결할 수 있는 실용적인 접근 방법을 제시하세요.
        """
      case .disgust:
        return """
        사용자는 지금 혐오감을 느끼고 있습니다. 혐오감은 강렬하고 때로는 부담스러운 감정일 수 있습니다. 
        사용자가 이 감정을 이해하고 처리할 수 있도록, 혐오감을 가라앉히고 상황을 객관적으로 바라볼 수 있는 방법에 대해 조언하세요. 
        또한, 긍정적인 시각으로 상황을 다시 생각할 수 있는 팁을 제공하세요.
        """
      case .fear:
        return """
        사용자는 지금 공포를 느끼고 있습니다. 공포는 우리를 위축시키는 강렬한 감정이지만, 
        이를 극복하기 위해서는 차분하게 현재 상황을 파악하고 자신을 보호할 수 있는 방법을 찾는 것이 중요합니다. 
        안전을 유지하면서도 공포를 줄이는 구체적인 행동 계획과 심리적인 안정감을 제공하세요.
        """
      case .neutral:
        return """
        사용자는 지금 중립의 감정을 가지고 있습니다. 중립적인 상태는 안정감이 있지만, 때로는 동기 부여가 부족할 수도 있습니다. 
        사용자가 자신의 감정을 탐색하고, 더 큰 행복과 성취감을 느낄 수 있는 방법에 대해 조언하세요. 
        또한, 스스로에게 작은 도전을 설정하고 이를 통해 기쁨을 찾는 방법을 제공하세요.
        """
      case .none:
        throw GenerativeAIError.invalidEmotion
      }
    }
  }
}
