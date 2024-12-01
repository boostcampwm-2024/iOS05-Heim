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
  func pushMusicRecommendationView(tracks: [MusicTrack])
  func pushHeimReplyView(diary: Diary)
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
  
  public func pushMusicRecommendationView(tracks: [MusicTrack]) {
    guard let musicUseCase = DIContainer.shared.resolve(type: MusicUseCase.self) else { return }
    let musicViewModel = MusicMatchViewModel(useCase: musicUseCase)
    let musicViewController = MusicMatchViewController(musics: tracks, viewModel: musicViewModel)
    navigationController.pushViewController(musicViewController, animated: true)
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
    guard let musicUseCase = DIContainer.shared.resolve(type: MusicUseCase.self) else { return nil }
    
    let viewModel = DiaryDetailViewModel(
      diaryUseCase: diaryUseCase,
      musicUseCase: musicUseCase,
      diary: diary
    )
    let viewController = DiaryDetailViewController(viewModel: viewModel)
    viewController.coordinator = self
    return viewController
  }
}
