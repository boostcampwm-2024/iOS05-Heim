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

  // MARK: - UI Components
  private let backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = .background
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  private let reportView: ReportView = {
    let reportView = ReportView()
    reportView.backgroundColor = .clear
    return reportView
  }()

  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupLayoutConstraints()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    coordinator?.didFinish()
  }

  // MARK: - LayOut Methods
  override func setupViews() {
    super.setupViews()
    view.addSubview(backgroundImageView)
    view.addSubview(reportView)

  }
  override func setupLayoutConstraints() {
    backgroundImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    reportView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

  }
  override func bindState() {
  }

  override func bindAction() {
  }
}

