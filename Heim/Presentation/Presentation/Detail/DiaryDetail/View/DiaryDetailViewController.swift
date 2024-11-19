//
//  DiaryDetailViewController.swift
//  Presentation
//
//  Created by 박성근 on 11/19/24.
//

import Domain
import UIKit

final class DiaryDetailViewController: BaseViewController<DiaryDetailViewModel>, Coordinatable {
  // MARK: - Properties
  weak var coordinator: DefaultDiaryDetailCoordinator?
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    
    coordinator?.didFinish()
  }
  
  override func bindState() {
    super.bindState()
  }
}
