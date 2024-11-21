//
//  ReportView.swift
//  Presentation
//
//  Created by 김미래 on 11/21/24.
//

import UIKit
import SnapKit

final class ReportView: UIView {

  // MARK: - Properties
  let userName = "성근"

  // MARK: - UI Components
  private let recordReportStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 10
//    stackView.backgroundColor = .brown
    stackView.distribution = .fillEqually
    return stackView
  }()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "하임이와 함께 한 기록"
    label.textColor = .white
    label.font = UIFont.boldFont(ofSize: LayoutContants.TitleOne)
    return label
  }()

  private let totalReportView: UIView = {
    let reportCountView = ReportCountView()
    reportCountView.layer.cornerRadius = 10
    reportCountView.layer.borderWidth = 1
    reportCountView.layer.borderColor = UIColor.white.cgColor
    return reportCountView
  }()

  private lazy var emotionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldFont(ofSize: LayoutContants.TitleThree)
    label.numberOfLines = 0
    label.text = """
    지난 30일간 \(userName)님께서 
    가장 많이 느끼신 감정은 슬픔이군요
    """
    label.textColor = .white
    label.textAlignment = .center
    return label
  }()
  //TODO: 그래프
  private let replyStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 10
    return stackView
  }()

  private let replyLabel: UILabel = {
    let label = UILabel()
    return label
  }()

  private let replayTextView: CommonTextAreaView = {
    let textAreaView = CommonTextAreaView()
    return textAreaView
  }()

  // MARK: - Initialize
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupRecordReportStackView()
    setupLayoutConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Layout
private extension ReportView {
  func setupViews() {
    self.backgroundColor = .clear
    addSubview(recordReportStackView)
    addSubview(emotionLabel)
  }

  func setupRecordReportStackView() {
    [titleLabel,totalReportView].forEach {
      recordReportStackView.addArrangedSubview($0)
    }
  }

  func setupLayoutConstraints() {
    recordReportStackView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide)
      $0.centerX.equalToSuperview()
      //TODO: 머지 된후 entension으로 수정예정 
      $0.height.equalTo(UIScreen.main.bounds.height * 0.2)
      $0.bottom.equalTo(emotionLabel.snp.top).offset(-48)

    }

    emotionLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
    }

  }
}

private extension ReportView {
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
