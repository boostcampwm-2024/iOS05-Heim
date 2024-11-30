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
  //TODO: 삭제
  public func start() {
    guard let musicMatchViewController = createMusicMatchViewController() else { return }
    navigationController.pushViewController(musicMatchViewController, animated: true)
  }

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

}

// MARK: - Private
private extension DefaultMusicMatchCoordinator {
  //TODO: 삭제!!
  func createMusicMatchViewController() -> MusicMatchViewController? {
    // TODO: 수정
    guard let useCase = DIContainer.shared.resolve(type: MusicUseCase.self) else { return nil }
    let viewModel = MusicMatchViewModel(useCase: useCase)
    let viewController = MusicMatchViewController(musics: [ MusicTrack(thumbnail: nil, title: "슈퍼노바", artist: "에스파", isrc: " KRA302100123")], viewModel: viewModel)
    viewController.coordinator = self
    return viewController
  }

  func createMusicMatchViewController(musicTracks: [MusicTrack]) -> MusicMatchViewController? {
    // TODO: 수정
    guard let useCase = DIContainer.shared.resolve(type: MusicUseCase.self) else { return nil }
    let viewModel = MusicMatchViewModel(useCase: useCase)
    let viewController = MusicMatchViewController(musics: [ MusicTrack(thumbnail: nil, title: "슈퍼노바", artist: "에스파", isrc: " KRA302100123")], viewModel: viewModel)
    viewController.coordinator = self
    return viewController
  }
}
