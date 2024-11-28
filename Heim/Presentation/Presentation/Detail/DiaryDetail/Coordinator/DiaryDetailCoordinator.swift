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
    // TODO: diaryDetailViewController 구현
    // navigationController.pushViewController(diaryDetailViewController, animated: true)
  }
  
  public func didFinish() {
    parentCoordinator?.removeChild(self)
  }
  
  public func pushMusicRecommendationView() {
    // TODO: 화면 연결
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
  }
}

// MARK: - Private
private extension DefaultDiaryDetailCoordinator {
  // TODO: diaryDetailViewController 구현
}
