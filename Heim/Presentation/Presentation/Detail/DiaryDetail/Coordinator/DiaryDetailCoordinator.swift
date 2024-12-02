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
  func pushMusicRecommendationView()
  func pushHeimReplyView(diary: Diary)
  // MARK: - 나의 이야기 다시듣기 이동
  func pushDiaryReplayView(diary: Diary, userName: String)
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
  
  public func pushMusicRecommendationView() {}
  
  public func pushHeimReplyView(diary: Diary) {
    let replyViewController = ReplyViewController(diary: diary)
    navigationController.pushViewController(replyViewController, animated: true)
  }
  
  public func pushDiaryReplayView(diary: Diary, userName: String) {
    let diaryReplayViewController = DiaryReplayViewController(
      viewModel: DiaryReplayViewModel(),
      diary: diary,
      userName: userName
    )
    navigationController.pushViewController(diaryReplayViewController, animated: true)
  }
}

// MARK: - Private
private extension DefaultDiaryDetailCoordinator {
  func createDiaryDetailViewController(diary: Diary) -> DiaryDetailViewController? {
    guard let diaryUseCase = DIContainer.shared.resolve(type: DiaryUseCase.self) else { return nil }
    guard let userUseCase = DIContainer.shared.resolve(type: UserUseCase.self) else { return nil }
    
    let viewModel = DiaryDetailViewModel(diaryUseCase: diaryUseCase, userUseCase: userUseCase, diary: diary)
    let viewController = DiaryDetailViewController(viewModel: viewModel)
    viewController.coordinator = self
    return viewController
  }
}
