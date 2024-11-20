//
//  ReportViewController.swift
//  Presentation
//
//  Created by 김미래 on 11/20/24.
//
import Domain
import UIKit

final class ReportViewController: BaseViewController<ReportViewModel>, Coordinatable {
  
  // MARK: - Properties
  weak var coordinator: DefaultReportCoordinator?

  // MARK: - LifeCycle
  override func viewDidLoad() {
    setupViews()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated) // 왜 함?
    coordinator?.didFinish()
  }

  // MARK: - Methods
  override func setupViews() {

  }
  override func bindState() {
  }

  override func bindAction() {
  }
}

