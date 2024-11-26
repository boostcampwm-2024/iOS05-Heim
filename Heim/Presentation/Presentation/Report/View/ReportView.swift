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
  var userName = "성근"
  var emotion = "슬픔"

  // MARK: - UI Components
  private let reportCountStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 10
    stackView.distribution = .fillEqually
    return stackView
  }()

  private let titleLabel = CommonLabel(text: "하임이와 함께 한 기록", font: .bold, size: LayoutConstants.titleOne, textColor: .white)
  private let totalReportView: UIView = {
    let reportCountView = ReportCountView()
    reportCountView.layer.cornerRadius = 10
    reportCountView.layer.borderWidth = 1
    reportCountView.layer.borderColor = UIColor.white.cgColor
    return reportCountView
  }()

  private lazy var emotionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldFont(ofSize: LayoutConstants.titleThree)
    label.numberOfLines = 0
    label.text = """
    지난 30일간 \(userName)님께서 
    가장 많이 느끼신 감정은 \(emotion)이군요
    """
    label.textColor = .white
    label.textAlignment = .center
    return label
  }()
  
  private let graphView = GraphView()
  private let replyTitleLabel = CommonLabel(text: "하임이의 답장", font: .bold, size: LayoutConstants.titleTwo, textColor: .white)
  private let replyTextView = CommonTextAreaView()

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
    addSubview(reportCountStackView)
    addSubview(emotionLabel)
    addSubview(graphView)
    addSubview(replyTitleLabel)
    addSubview(replyTextView)
  }

  func setupRecordReportStackView() {
    [titleLabel, totalReportView].forEach {
      reportCountStackView.addArrangedSubview($0)
    }
  }
  //TODO: 스크린 사이즈 entension으로 수정
  func setupLayoutConstraints() {
    reportCountStackView.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide)
      $0.centerX.equalToSuperview()
      $0.height.equalTo(UIScreen.main.bounds.height * LayoutConstants.reportCountStackViewHeight)
      $0.bottom.equalTo(emotionLabel.snp.top).offset(LayoutConstants.reportCountStackViewBottom)
    }

    emotionLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
    }

    graphView.snp.makeConstraints {
      $0.top.equalTo(emotionLabel.snp.bottom).offset(LayoutConstants.defaultPadding)
      $0.height.equalTo(UIScreen.main.bounds.height * LayoutConstants.graphViewHeight)
      $0.width.equalTo((UIScreen.main.bounds.width - LayoutConstants.graphViewWidth))
      $0.centerX.equalToSuperview()
    }

    replyTitleLabel.snp.makeConstraints {
      $0.top.equalTo(graphView.snp.bottom).offset(LayoutConstants.defaultPadding)
      $0.centerX.equalToSuperview()
    }

    replyTextView.snp.makeConstraints {
      $0.top.equalTo(replyTitleLabel.snp.bottom).offset(LayoutConstants.defaultPadding)
      $0.leading.trailing.equalToSuperview().inset(LayoutConstants.defaultPadding)
    }
  }
}

private extension ReportView {
  enum LayoutConstants {
    static let defaultPadding: CGFloat = 16
    static let titleOne: CGFloat = 28
    static let titleTwo: CGFloat = 24
    static let titleThree: CGFloat = 20
    static let reportCountStackViewHeight: CGFloat = 0.2
    static let reportCountStackViewBottom: CGFloat = -32
    static let graphViewHeight: CGFloat = 0.2
    static let graphViewWidth: CGFloat = 128
  }
}
