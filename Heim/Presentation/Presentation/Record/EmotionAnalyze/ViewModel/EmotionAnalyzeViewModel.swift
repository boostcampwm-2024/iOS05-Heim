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
  }
  
  private let recognizedText: String // RecordView에서 넘어온 인식된 텍스트
  private let voice: Voice // RecordView에서 넘어온 음성 녹음
  private let classifyUseCase: EmotionClassifyUseCase
  private var emotion: Emotion = .none
  private var heimReply: EmotionReport = EmotionReport(text: "")
  private var summary: Summary = Summary(text: "")
  
  @Published var state: State
  // TODO: GEMINI 이용 UseCase 추가
  
  init(
    recognizedText: String,
    voice: Voice,
    classifyUseCase: EmotionClassifyUseCase
    // TODO: GEMINI 이용 UseCase 추가
  ) {
    self.recognizedText = recognizedText
    self.voice = voice
    self.state = State(isAnalyzing: true)
    self.classifyUseCase = classifyUseCase
  }
  
  func action(_ action: Action) {
    Task {
      async let emotionResult = classifyUseCase.validate(recognizedText) // 2개의 구조적 동시성 작업을 위해 async let을 사용
      
      // TODO: GEMINI UseCase 추가. 아래는 예시로 더미데이터를 사용, 삭제 예정
      let heimResult = EmotionReport(text: "감정분석")
      let summary = Summary(text: "요약")
      
      do {
        let (emotion, heimReply, summary) = try await (emotionResult, heimResult, summary)
        self.emotion = emotion
        self.heimReply = heimReply
        self.summary = summary
        
        sleep(5) // GEMINI의 응답이 5초 걸린다고 가정
        
        // 모든 작업이 완료되면 isAnalyzing을 false로 설정
        state.isAnalyzing = false
      } catch {
        // TODO: 에러 처리
        state.isAnalyzing = false
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
