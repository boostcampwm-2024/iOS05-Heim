//
//  EmotionAnalyzeViewModel.swift
//  Presentation
//
//  Created by 박성근 on 11/23/24.
//

import Combine
import Core
import Domain
import Foundation

final class EmotionAnalyzeViewModel: ViewModel {
  // MARK: - Properties
  enum Action {
    case analyze // CoreML로 감정 분석, GEMINI를 이용한 답장 받기를 동시에 수행
  }
  
  struct State {
    var isAnalyzing: Bool
    var isErrorPresent: Bool = false
  }
  
  private let recognizedText: String // RecordView에서 넘어온 인식된 텍스트
  private let voice: Voice // RecordView에서 넘어온 음성 녹음
  private let classifyUseCase: EmotionClassifyUseCase
  private let emotionUseCase: GenerativeEmotionPromptUseCase
  private let summaryUseCase: GenerativeSummaryPromptUseCase
  private var emotion: Emotion = .none
  private var heimReply: EmotionReport = EmotionReport(text: "")
  private var summary: Summary = Summary(text: "")
  
  @Published var state: State
  
  init(
    recognizedText: String,
    voice: Voice,
    classifyUseCase: EmotionClassifyUseCase,
    emotionUseCase: GenerativeEmotionPromptUseCase,
    summaryUseCase: GenerativeSummaryPromptUseCase
  ) {
    self.recognizedText = recognizedText
    self.voice = voice
    self.state = State(isAnalyzing: true)
    self.classifyUseCase = classifyUseCase
    self.emotionUseCase = emotionUseCase
    self.summaryUseCase = summaryUseCase
  }
  
  func action(_ action: Action) {
    Task {
      async let emotionResult = classifyUseCase.validate(recognizedText)
      async let summary = summaryUseCase.generate(recognizedText)
      
      do {
        let emotion = try await emotionResult
        self.emotion = emotion
        
        let heimReply = try await emotionUseCase.generate(emotion.rawValue)
        let summary = try await summary
        
        guard let heimReply = heimReply else { return }
        
        self.heimReply = EmotionReport(text: heimReply)
        self.summary = Summary(text: summary ?? "")
        
        state.isAnalyzing = false
      } catch {
        state.isAnalyzing = false
        state.isErrorPresent = true
      }
    }
  }
  
  func diaryData() -> Diary {
    return Diary(
      calendarDate: Date().calendarDate(),
      emotion: emotion,
      emotionReport: heimReply,
      voice: voice,
      summary: summary
    )
  }
}
