//
//  ReportViewModel.swift
//  Presentation
//
//  Created by 김미래 on 11/20/24.
//

import Combine
import Core
import Domain

final class ReportViewModel: ViewModel {

  // MARK: - Properties
  enum Action {
    //TODO: 수정
    case fetchData
  }

  struct EmotionCount: Equatable {
    var sadCount: Int
    var happyCount: Int
    var surpriseCount: Int
    var fearCount: Int
    var disgustCount: Int
    var neutralCount: Int
    var angryCount: Int
  }

  struct State: Equatable {
    var userName: String
    var totalCount: Int
    var sequenceCount: Int
    var monthCount: Int
    var emotionCount: EmotionCount
    var emotion: String
    var reply: String
  }

  // TODO: UseCase 추가
  private let useCase: DiaryUseCase
  @Published var state: State

  // MARK: - Initializer
  // TODO: Initializer에 UseCase 추가
  init(useCase: DiaryUseCase) {
    self.state = State(userName: "미래", // TODO: userName
                       totalCount: 0,
                       sequenceCount: 0,
                       monthCount: 0,
                       emotionCount: EmotionCount(sadCount: 0,
                                                  happyCount: 0,
                                                  surpriseCount: 0,
                                                  fearCount: 0,
                                                  disgustCount: 0,
                                                  neutralCount: 0,
                                                  angryCount: 0),
                       emotion: "",
                       reply: "답장이 도착하지 않았어요!")
    self.useCase = useCase
  }

  func action(_ action: Action) {
    switch action {
    case .fetchData:
      Task {
        await fetchData()
      }
    }
  }
}

// MARK: - Private Extenion
private extension ReportViewModel {
  func fetchData() async{
    do {
      state.totalCount = try await useCase.countTotalDiary()
      // TODO: 30일 다이어리 가지고 오기
      // TODO: countEmotion()
      // TODO: returnMajorEmotion()
    } catch {
      // TODO: 에러
    }
  }

  func countEmotion(diarys: [Diary]) {
    for diary in diarys {
      switch diary.emotion {
      case .sadness:
        state.emotionCount.sadCount += 1
      case .happiness:
        state.emotionCount.happyCount += 1
      case .angry:
        state.emotionCount.angryCount += 1
      case .surprise:
        state.emotionCount.surpriseCount += 1
      case .fear:
        state.emotionCount.fearCount += 1
      case .disgust:
        state.emotionCount.disgustCount += 1
      case .neutral:
        state.emotionCount.neutralCount += 1
      case .none:
        break
      @unknown default:
        continue
      }
    }
  }

  func returnMajorEmotion() {
    let emotionCounts = state.emotionCount
    let totalEmotionCounts = [
      ("슬픔", emotionCounts.sadCount),
      ("행복", emotionCounts.happyCount),
      ("화남", emotionCounts.angryCount),
      ("놀람", emotionCounts.surpriseCount),
      ("공포", emotionCounts.fearCount),
      ("혐오", emotionCounts.disgustCount),
      ("중립", emotionCounts.neutralCount)
    ]

    guard let majorEmotion = totalEmotionCounts.max(by: { $0.1 < $1.1 }) else {
      state.emotion = "없음"
      return
    }
    state.emotion = majorEmotion.0
    // TODO: 재미나이 호출
    // state.reply
  }
}
