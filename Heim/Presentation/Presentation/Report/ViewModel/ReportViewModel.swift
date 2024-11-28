//
//  ReportViewModel.swift
//  Presentation
//
//  Created by 김미래 on 11/20/24.
//

import Combine
import Core
import Domain

struct EmotionValue: Equatable {
  var sadCount: Int
  var happyCount: Int
  var surpriseCount: Int
  var fearCount: Int
  var disgustCount: Int
  var neutralCount: Int
  var angryCount: Int
}

final class ReportViewModel: ViewModel {

  // MARK: - Properties
  enum Action {
    //TODO: 수정
    case fetchData
  }



  struct State: Equatable {
    var userName: String
    var totalCount: Int
    var sequenceCount: Int
    var monthCount: Int
    var emotionValue: EmotionValue
    var emotion: String
    var reply: String

  }

  // TODO: UseCase 추가
  private let useCase: DiaryUseCase
  @Published var state: State

  // MARK: - Initializer
  // TODO: Initializer에 UseCase 추가
  init(useCase: DiaryUseCase) {
    self.state = State(userName: "사용자", // TODO: userName
                       totalCount: 0,
                       sequenceCount: 0,
                       monthCount: 0,
                       emotionValue: EmotionValue(sadCount: 0,
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
    let totalCount = diarys.count
    var sadCount = 0
    var happyCount = 0
    var surpriseCount = 0
    var fearCount = 0
    var disgustCount = 0
    var neutralCount = 0
    var angryCount = 0

    for diary in diarys {
      switch diary.emotion {
      case .sadness:
        sadCount += 1
      case .happiness:
        happyCount += 1
      case .angry:
        angryCount += 1
      case .surprise:
        surpriseCount += 1
      case .fear:
        fearCount += 1
      case .disgust:
        disgustCount += 1
      case .neutral:
        neutralCount += 1
      case .none:
        break
      @unknown default:
        continue
      }
    }

    state.emotionValue = EmotionValue(sadCount: sadCount / totalCount,
                                     happyCount: happyCount / totalCount,
                                     surpriseCount: surpriseCount / totalCount,
                                     fearCount: fearCount / totalCount,
                                     disgustCount: disgustCount / totalCount,
                                     neutralCount: neutralCount / totalCount,
                                     angryCount: angryCount / totalCount)

  }

  func returnMajorEmotion() {
    let emotionCounts = state.emotionValue
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
