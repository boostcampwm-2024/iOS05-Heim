//
//  ReportCountView.swift
//  Presentation
//
//  Created by 김미래 on 11/21/24.
//

import UIKit

// 상단 일기 갯수 표
final class ReportCountView: UIView {
  // MARK: - Properties
  private let totalCount = CommonLabel(text: "30", font: .bold, size: LayoutContants.titleThree, textColor: .white)
  private let continuousCount = CommonLabel(text: "10", font: .bold, size: LayoutContants.titleThree, textColor: .white)
  private let monthCount = CommonLabel(text: "3", font: .bold, size: LayoutContants.titleThree, textColor: .white)

  private let countTitleStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = LayoutContants.defaultPadding * 2
    stackView.distribution = .fillEqually

    let labelOne = CommonLabel(text: "전체", font: .regular, size: LayoutContants.bodyOne, textColor: .white)
    let labelTwo = CommonLabel(text: "연속 작성", font: .regular, size: LayoutContants.bodyOne, textColor: .white)
    let labelThree = CommonLabel(text: "지난 30일", font: .regular, size: LayoutContants.bodyOne, textColor: .white)

    [labelOne, labelTwo, labelThree].forEach {
      $0.textAlignment = .center
      stackView.addArrangedSubview($0)
    }
    return stackView
  }()

  private let countStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = LayoutContants.defaultPadding * 2
    stackView.distribution = .fillEqually
    return stackView
  }()

  // MARK: - Initialize
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupCountStackView()
    setupTotalRecordStackView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Layout
private extension ReportCountView {
  func setupViews() {
    [countTitleStackView, countStackView].forEach {
      addSubview($0)
    }
  }

  func setupCountStackView() {
    [totalCount, continuousCount, monthCount].forEach {
      $0.textAlignment = .center
      countStackView.addArrangedSubview($0)
    }
  }

  func setupTotalRecordStackView() {
    countTitleStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(LayoutContants.defaultPadding)
      $0.centerX.equalToSuperview()
    }

    countStackView.snp.makeConstraints {
      $0.top.equalTo(countTitleStackView.snp.bottom).offset(LayoutContants.defaultPadding)
      $0.width.equalToSuperview()
      $0.centerX.equalToSuperview()
    }
  }
}

private extension ReportCountView {
  enum LayoutContants {
    static let defaultPadding: CGFloat = 16
    static let titleThree: CGFloat = 20
    static let bodyOne: CGFloat = 16
  }
}
