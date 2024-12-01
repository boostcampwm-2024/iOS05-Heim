//
//  DiaryDetailViewModel.swift
//  Presentation
//
//  Created by 박성근 on 11/19/24.
//

import Combine
import Core
import Domain
import Foundation

final class DiaryDetailViewModel: ViewModel {
  // MARK: - Properties
  enum Action {
    case fetchDiary
    case deleteDiary
    case fetchMusicTrack
  }
  
  struct State: Equatable {
    var calendarDate: String = ""
    var description: String = ""
    var content: String = ""
    var isDeleted: Bool = false
    var musicTrack: [MusicTrack] = []
    var errorMessage: String?
  }
  
  @Published var state: State
  private let diaryUseCase: DiaryUseCase
  private let musicUseCase: MusicUseCase
  // TODO: 이름 가져오는 기능 추가
  private let userName: String = "성근"
  let diary: Diary
  
  // MARK: - Initializer
  init(
    diaryUseCase: DiaryUseCase,
    musicUseCase: MusicUseCase,
    diary: Diary
  ) {
    state = State()
    self.diaryUseCase = diaryUseCase
    self.musicUseCase = musicUseCase
    self.diary = diary
  }
  
  // MARK: - Methods
  func action(_ action: Action) {
    switch action {
    case .fetchDiary:
      setupInitialState()
    case .deleteDiary:
      Task {
        await handleDeleteDiary()
      }
    case .fetchMusicTrack:
      fetchMusicTrack()
    }
  }
}

// MARK: - Private Extenion
private extension DiaryDetailViewModel {
  func handleDeleteDiary() async {
    do {
      try await diaryUseCase.deleteDiary(calendarDate: diary.calendarDate)
      state.isDeleted = true
    } catch {
      // TODO: Error Handling
    }
  }
  
  func setupInitialState() {
    state.calendarDate = "\(diary.calendarDate.year)년 \(diary.calendarDate.month)월 \(diary.calendarDate.day)일"
    state.description = diary.emotion.diaryDetailDescription(with: userName)
    state.content = diary.summary.text
  }
  
  func fetchMusicTrack() {
    Task.detached { [weak self] in
      guard let self else { return }
      do {
        let tracks = try await musicUseCase.fetchRecommendTracks(self.diary.emotion)
        self.state.musicTrack = tracks
      } catch TokenError.refreshTokenExpired {
        self.state.errorMessage = TokenError.refreshTokenExpired.description
      }
    }
  }
}
