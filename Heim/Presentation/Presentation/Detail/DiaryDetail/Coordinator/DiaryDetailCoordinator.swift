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
  // MARK: - 하임이의 답장 보러가기 이동
  func pushHeimReplyView()
  // MARK: - 나의 이야기 다시듣기 이동
  func pushDiaryReplayView()
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
    guard let diaryDetailViewController = diaryDetailViewController(diary) else { return }
    navigationController.pushViewController(diaryDetailViewController, animated: true)
  }
  
  public func didFinish() {
    parentCoordinator?.removeChild(self)
  }
  
  public func pushMusicRecommendationView() {
    // TODO: 화면 연결
  }
  
  public func pushHeimReplyView() {
    // TODO: 화면 연결
  }
  
  public func pushDiaryReplayView() {
    // TODO: 화면 연결
  }
  
}

// MARK: - Private
private extension DefaultDiaryDetailCoordinator {
  func diaryDetailViewController(_ diary: Diary) -> DiaryDetailViewController? {
    // TODO: TimeStamp, UseCase 주입
    
    // guard let dataStorageUseCase = DIContainer.shared.resolve(type: DataStorageUseCase.self) else { return nil }
    let viewModel = DiaryDetailViewModel(diary: diary)
    let viewController = DiaryDetailViewController(viewModel: viewModel)
    viewController.coordinator = self
    return viewController
  }
}
