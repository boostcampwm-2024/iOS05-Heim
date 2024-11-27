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
  private let labelOne = CommonLabel(text: "전체", font: .regular, size: LayoutContants.bodyOne, textColor: .white)
  private let labelTwo = CommonLabel(text: "연속 작성", font: .regular, size: LayoutContants.bodyOne, textColor: .white)
  private let labelThree = CommonLabel(text: "지난 30일", font: .regular, size: LayoutContants.bodyOne, textColor: .white)
  
  private let totalCountStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private let continuousStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private let monthStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private let totalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.distribution = .fillProportionally
    return stackView
  }()

  // MARK: - Initialize
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupLayoutContstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Layout
private extension ReportCountView {
  func setupViews() {
    [totalCountStackView, continuousStackView, monthStackView].forEach {
      addSubview($0)
    }
    
    totalCountStackView.addArrangedSubview(labelOne)
    totalCountStackView.addArrangedSubview(totalCount)
    continuousStackView.addArrangedSubview(labelTwo)
    continuousStackView.addArrangedSubview(continuousCount)
    monthStackView.addArrangedSubview(labelThree)
    monthStackView.addArrangedSubview(monthCount)
    totalStackView.addArrangedSubview(totalCountStackView)
    totalStackView.addArrangedSubview(continuousStackView)
    totalStackView.addArrangedSubview(monthStackView)
    addSubview(totalStackView)
    
    [totalCount, continuousCount, monthCount, labelOne, labelTwo, labelThree].forEach {
      $0.textAlignment = .center
    }
  }

  func setupLayoutContstraints() {
    totalCountStackView.snp.makeConstraints {
      $0.width.equalTo(UIApplication.screenWidth * 0.158)
      $0.height.equalTo(90)
    }
    
    continuousCount.snp.makeConstraints {
      $0.width.equalTo(UIApplication.screenWidth * 0.238)
    }
    
    monthCount.snp.makeConstraints {
      $0.width.equalTo(UIApplication.screenWidth * 0.246)
    }
    
    totalStackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
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
