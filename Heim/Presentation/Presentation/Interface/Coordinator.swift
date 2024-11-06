//
//  Coordinator.swift
//  Presentation
//
//  Created by 정지용 on 11/6/24.
//

import UIKit

public protocol Coordinator: AnyObject {
  // MARK: - Properties
  var parentCoordinator: Coordinator? { get set }
  var childCoordinators: [Coordinator] { get set }
  var navigationController: UINavigationController { get set }
  
  // MARK: - Methods
  func start()
  func didFinish()
}

// MARK: - Default Implementation
public extension Coordinator {
  func addChild(
    _ child: Coordinator
  ) {
    childCoordinators.append(child)
  }
  
  func removeChild(
    _ child: Coordinator?
  ) {
    for (idx, coordinator) in childCoordinators.enumerated() where coordinator === child {
      childCoordinators.remove(at: idx)
      break
    }
  }
}
