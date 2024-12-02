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
  func start(musicTracks: [MusicTrack])
  func backToMainView()
  func createMusicMatchViewController(musicTracks: [MusicTrack]) -> MusicMatchViewController?
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
  public func start() {}
  public func start(musicTracks: [MusicTrack]) {
    guard let musicMatchViewController = createMusicMatchViewController(musicTracks: musicTracks) else { return }
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
  
  public func createMusicMatchViewController(musicTracks: [MusicTrack]) -> MusicMatchViewController? {
    guard let useCase = DIContainer.shared.resolve(type: MusicUseCase.self) else { return nil }
    
    let viewModel = MusicMatchViewModel(useCase: useCase)
    let viewController = MusicMatchViewController(musics: musicTracks, viewModel: viewModel)
    viewController.coordinator = self
    return viewController
  }
}
