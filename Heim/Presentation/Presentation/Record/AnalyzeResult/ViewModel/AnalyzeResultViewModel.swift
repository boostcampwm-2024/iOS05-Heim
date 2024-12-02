//
//  AnalyzeResultViewModel.swift
//  Presentation
//
//  Created by 박성근 on 11/27/24.
//

import Combine
import Core
import Domain
import Foundation

final class AnalyzeResultViewModel: ViewModel {
  // MARK: - Properties
  enum Action {
    case fetchDiary
    case fetchMusicTrack
  }
  
  struct State: Equatable {
    var description: String = ""
    var content: String = ""
    var isFetchFailed: Bool = false
    var musicTrack: [MusicTrack] = []
  }
  
  @Published var state: State
  private let diaryUseCase: DiaryUseCase
  private let musicUseCase: MusicUseCase
  private var diary: Diary
  
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
      handleSaveDiary()
    case .fetchMusicTrack:
      fetchMusicTrack()
    }
  }
}

// MARK: - Private Extenion
private extension AnalyzeResultViewModel {
  func handleSaveDiary() {
    Task.detached { [weak self] in
      do {
        guard let diary = self?.diary else { return }
        try await self?.diaryUseCase.saveDiary(data: diary)
      } catch {
        // TODO: Error Handling
      }
    }
  }
  
  func setupInitialState() {
    // TODO:
    state.description = diary.emotion.rawValue
    state.content = diary.emotionReport.text
  }
  
  func fetchMusicTrack() {
    Task.detached { [weak self] in
      guard let self else { return }
      do {
        let tracks = try await musicUseCase.fetchRecommendTracks(self.diary.emotion)
        self.state.musicTrack = tracks
      } catch TokenError.refreshTokenExpired {
        self.state.isFetchFailed = true
      } catch {
        print(error)
      }
    }
  }
}

