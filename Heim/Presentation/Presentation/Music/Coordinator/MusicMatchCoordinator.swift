//
//  MusicMatchCoordinator.swift
//  Presentation
//
//  Created by 김미래 on 11/25/24.
//

import Core
import Domain
import UIKit

public protocol MusicMatchCoordinator: Coordinator {
  func backToMainView()
  func createMusicMatchViewController() -> MusicMatchViewController?
}

public final class DefaultMusicMatchCoordinator: MusicMatchCoordinator {
  // MARK: - Properties
  public weak var parentCoordinator: Coordinator?
  public var childCoordinators: [Coordinator] = []
  public var navigationController: UINavigationController

  // MARK: - Initialize
  public init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
  public func start() {
    guard let musicMatchViewController = createMusicMatchViewController() else { return }
    navigationController.pushViewController(musicMatchViewController, animated: true)
  }
  
  public func didFinish() {
    parentCoordinator?.removeChild(self)
  }

  public func backToMainView() {
    parentCoordinator?.removeChild(self)
    parentCoordinator?.parentCoordinator?.removeChild(parentCoordinator)
    parentCoordinator?.parentCoordinator?.parentCoordinator?.removeChild(parentCoordinator?.parentCoordinator)
    
    navigationController.dismiss(animated: true)
  }

  public func createMusicMatchViewController() -> MusicMatchViewController? {
    // TODO: 수정
    let viewModel = MusicMatchViewModel()
    let viewController = MusicMatchViewController(
      musics: [Music(title: "Supernova", artist: "aespa")],
      viewModel: viewModel
    )
    viewController.coordinator = self
    return viewController
  }
}
