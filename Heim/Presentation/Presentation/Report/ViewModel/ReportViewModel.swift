//
//  ReportViewModel.swift
//  Presentation
//
//  Created by 김미래 on 11/20/24.
//

import Combine
import Core
import Domain

public final class ReportViewModel: ViewModel {

  // MARK: - Properties
  public enum Action {
    case fetchUserName
    case fetchTotalDiaryCount
    case fetchContinuousCount
    case fetchMonthCount
  }
  
  public struct State: Equatable {
    var userName: String
    var totalCount: String
    var continuousCount: String
    var monthCount: String
    var emotionCountDictionary: [Emotion: Int]
    var mainEmotionTitle: String
    var reply: String
  }

  let userUseCase: UserUseCase
  let diaryUseCase: DiaryUseCase
  @Published public var state: State

  // MARK: - Initializer
  init(
    userUseCase: UserUseCase,
    diaryUseCase: DiaryUseCase
  ) {
    self.userUseCase = userUseCase
    self.diaryUseCase = diaryUseCase
    
    state = State(
      userName: "",
      totalCount: "0",
      continuousCount: "0",
      monthCount: "0",
      emotionCountDictionary: [:],
      mainEmotionTitle: "",
      reply: ""
    )
  }

  // MARK: - Methods
  public func action(_ action: Action) {
    switch action {
    case .fetchUserName: fetchUserName()
    case .fetchTotalDiaryCount: fetchTotalDiaryCount()
    case .fetchContinuousCount: fetchContinuousCount()
    case .fetchMonthCount: fetchMonthCount()
    }
  }
}

// MARK: - Private Extenion
private extension ReportViewModel {
  func fetchUserName() {
    Task.detached { [weak self] in
      do {
        self?.state.userName = try await self?.userUseCase.fetchUserName() ?? "User"
      } catch {
        self?.state.userName = "User"
      }
    }
  }
  
  func fetchTotalDiaryCount() {
    Task.detached { [weak self] in
      do {
        let diaries = try await self?.diaryUseCase.readTotalDiaries()
        self?.state.totalCount = String(diaries?.count ?? 0)
        self?.setEmotionCount(from: diaries ?? [])
      } catch {
        self?.state.totalCount = "0"
        self?.setEmotionCount(from: [])
      }
    }
  }
  
  func fetchContinuousCount() {
    Task.detached { [weak self] in
      do {
        self?.state.continuousCount = String(try await self?.diaryUseCase.fetchContinuousCount() ?? 0)
      } catch {
        self?.state.continuousCount = "0"
      }
    }
  }
  
  func fetchMonthCount() {
    Task.detached { [weak self] in
      do {
        self?.state.monthCount = String(try await self?.diaryUseCase.fetchMonthCount() ?? 0)
      } catch {
        self?.state.monthCount = "0"
      }
    }
  }
  
  func setEmotionCount(from diaries: [Diary]) {
    var emotionCountDictionary: [Emotion: Int] = [:]
    
    diaries
      .map { $0.emotion }
      .forEach {
        emotionCountDictionary[$0, default: 0] += 1
      }
    
    for emotion in Emotion.allCases where emotionCountDictionary[emotion] == nil && emotion != .none {
      emotionCountDictionary[emotion] = 0
    }
    
    let maxEmotion = emotionCountDictionary.max { $0.value < $1.value }
    state.emotionCountDictionary = emotionCountDictionary
    state.mainEmotionTitle = maxEmotion?.value != 0 ? maxEmotion?.key.title ?? "" : ""
    
    let recentReply = diaries
      .filter { $0.emotion == maxEmotion?.key }
      .sorted { $0.calendarDate.year > $1.calendarDate.year }
      .sorted { $0.calendarDate.month > $1.calendarDate.month }
      .sorted { $0.calendarDate.day > $1.calendarDate.day }
      .first?
      .emotionReport
    
    let defaultReply = """
    오늘 하루의 이야기를 써 내려가는 일은, 당신의 마음을 정리하고 성장의 기반을 다지는 소중한 시간이 됩니다.
    하임이와 함께 당신의 감정을 기록하며 숨겨진 마음의 이야기를 발견해보세요.
    매일 단 몇 줄이라도, 당신만의 특별한 감정을 따뜻하게 보듬고 멋진 이야기를 만들어갈 수 있습니다. 
    오늘부터 하임이와 함께 시작해볼까요? 
    당신의 하루는 분명 기록을 남길 가치가 있습니다!
    """
    state.reply = recentReply?.text ?? defaultReply
  }
}
