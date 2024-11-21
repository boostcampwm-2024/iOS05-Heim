//
//  ReportCountView.swift
//  Presentation
//
//  Created by 김미래 on 11/21/24.
//

import UIKit

final class ReportCountView: UIView {

  private let countTitleStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = LayoutContants.defaultPadding * 2
    stackView.distribution = .fill

    let labelOne = UILabel()
    labelOne.text = "전체"

    let labelTwo = UILabel()
    labelTwo.text = "연속 작성"

    let labelThree = UILabel()
    labelThree.text = "지난 30일"

    [labelOne, labelTwo, labelThree].forEach {
      $0.textColor = .white
      $0.font = UIFont.regularFont(ofSize: LayoutContants.bodyOne)
      $0.textAlignment = .center
      stackView.addArrangedSubview($0)
    }
    return stackView
  }()

  private let countStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = LayoutContants.defaultPadding * 2
    stackView.distribution = .fillEqually

    let totalCount = UILabel()
    totalCount.text = "10"

    let continuousCount = UILabel()
    continuousCount.text = "30"

    let monthCount = UILabel()
    monthCount.text = "3"

    [totalCount, continuousCount, monthCount].forEach {
      $0.textColor = .white
      $0.font = UIFont.boldFont(ofSize: LayoutContants.TitleThree)
      $0.textAlignment = .center

      stackView.addArrangedSubview($0)
    }
    return stackView
  }()




  // MARK: - Initialize
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
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

  func setupTotalRecordStackView() {
    countTitleStackView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(LayoutContants.defaultPadding)
      $0.centerX.equalToSuperview()
    }

    countStackView.snp.makeConstraints {
      $0.top.equalTo(countTitleStackView.snp.bottom).offset(LayoutContants.defaultPadding)
//      $0.bottom.equalToSuperview().offset(-LayoutContants.defaultPadding)
      $0.width.equalToSuperview()
      $0.centerX.equalToSuperview()
    }

  }

}

private extension ReportCountView {
  enum LayoutContants {
    static let defaultPadding: CGFloat = 16
    static let TitleOne: CGFloat = 28
    static let TitleTwo: CGFloat = 24
    static let TitleThree: CGFloat = 20
    static let bodyOne: CGFloat = 16
    static let bodyTwo: CGFloat = 24
    static let bodyThree: CGFloat = 12


  }
}

