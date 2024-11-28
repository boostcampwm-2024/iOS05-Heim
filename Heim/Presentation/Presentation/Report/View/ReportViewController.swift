//
//  ReportViewController.swift
//  Presentation
//
//  Created by 김미래 on 11/20/24.
//
import Domain
import UIKit

public final class ReportViewController: BaseViewController<ReportViewModel>, Coordinatable {
  // MARK: - Properties
  weak var coordinator: DefaultReportCoordinator?

  // MARK: - UI Components
  private let scrollView: UIScrollView = {
      let scrollView = UIScrollView()
      scrollView.showsVerticalScrollIndicator = false
      return scrollView
    }()

  private let reportView: ReportView = {
    let reportView = ReportView()
    reportView.backgroundColor = .clear
    return reportView
  }()

  // MARK: - LifeCycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    setupLayoutConstraints()
  }

  deinit {
    coordinator?.didFinish()
  }

  // MARK: - LayOut Methods
  override func setupViews() {
    super.setupViews()
    
    view.addSubview(scrollView)
    scrollView.addSubview(reportView)
  }

  override func setupLayoutConstraints() {
    super.setupLayoutConstraints()
    scrollView.snp.makeConstraints {
         $0.edges.equalToSuperview()
       }

    reportView.snp.makeConstraints {
      $0.edges.width.equalToSuperview()
      $0.height.equalToSuperview()
    }
  }

  override func bindState() {
  }

  override func bindAction() {
  }
}
