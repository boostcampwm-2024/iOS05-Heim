//
//  DiaryDetailCoordinator.swift
//  Presentation
//
//  Created by 박성근 on 11/19/24.
//

import Core
import Domain
import UIKit

public protocol DiaryDetailCoordinator: Coordinator {
  func start(diary: Diary)
  // MARK: - 추천음악 감상하기로 이동
  func pushMusicRecommendationView(musicTracks: [MusicTrack])
  func pushHeimReplyView(diary: Diary)
  // MARK: - 나의 이야기 다시듣기 이동
  func pushDiaryReplayView(diary: Diary)
}

public final class DefaultDiaryDetailCoordinator: DiaryDetailCoordinator {
  // MARK: - Properties
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []
  public var navigationController: UINavigationController
  
  // MARK: - Initialize
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Methods
  public func start() {}
  
  public func start(diary: Diary) {
    guard let diaryDetailViewController = createDiaryDetailViewController(diary: diary) else { return }
    navigationController.pushViewController(diaryDetailViewController, animated: true)
  }
  
  public func didFinish() {
    parentCoordinator?.removeChild(self)
    navigationController.popViewController(animated: true)
  }
  
  public func pushMusicRecommendationView(musicTracks: [MusicTrack]) {
    guard let musicMatchCoordinator = DIContainer.shared.resolve(type: MusicMatchCoordinator.self) else {
      return
    }
    
    guard let musicMatchViewController = musicMatchCoordinator.createMusicMatchViewController(musicTracks: musicTracks) else {
      return
    }
    
    navigationController.pushViewController(musicMatchViewController, animated: true)
  }
  
  public func pushHeimReplyView(diary: Diary) {
    let replyViewController = ReplyViewController(diary: diary)
    navigationController.pushViewController(replyViewController, animated: true)
  }
  
  public func pushDiaryReplayView(diary: Diary) {
    let diaryReplayViewController = DiaryReplayViewController(
      viewModel: DiaryReplayViewModel(),
      diary: diary
    )
    navigationController.pushViewController(diaryReplayViewController, animated: true)
  }
}

// MARK: - Private
private extension DefaultDiaryDetailCoordinator {
  func createDiaryDetailViewController(diary: Diary) -> DiaryDetailViewController? {
    guard let diaryUseCase = DIContainer.shared.resolve(type: DiaryUseCase.self) else { return nil }
    
    
    let viewModel = DiaryDetailViewModel(useCase: diaryUseCase, diary: diary)
    let viewController = DiaryDetailViewController(viewModel: viewModel)
    viewController.coordinator = self
    return viewController
  }
}
