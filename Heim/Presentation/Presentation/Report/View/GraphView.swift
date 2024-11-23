//
//  GraphView.swift
//  Presentation
//
//  Created by 김미래 on 11/22/24.
//

import UIKit

final class GraphView: UIView {

  let emotionCharts: [Chart] =
  [Chart(value: 0.1, color: .red),
   Chart(value: 1.0, color: .blue),
   Chart(value: 0.3, color: .white),
   Chart(value: 0.7, color: .yellow),
   Chart(value: 0.6, color: .black),
   Chart(value: 0.5, color: .orange),
   Chart(value: 0.5, color: .brown)]

  private let emotionEmojis = HeimEmoji.defaultEmotions()

  private let graphStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = LayoutContants.defaultPadding
    stackView.distribution = .fillEqually
    return stackView
  }()

  private let emotionStack: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = LayoutContants.defaultPadding
    stackView.distribution = .fillEqually
    return stackView
  }()

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupGraphStackView()
    setupEmojiStackView()
    setupLayoutConstraints()
  }
  // TODO: [Chart]파라미터로 하는 Initializer 만들기
}

// MARK: - Layout
private extension GraphView {
  func setupViews() {
    addSubview(graphStackView)
    addSubview(emotionStack)
  }

  func setupGraphStackView() {
    emotionCharts.forEach {
      let barView = BarView(chart: $0)
      graphStackView.addArrangedSubview(barView)
    }
  }

  func setupEmojiStackView() {
    emotionEmojis.forEach {
      emotionStack.addArrangedSubview($0)
    }
  }

  func setupLayoutConstraints() {
    graphStackView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(self.snp.height).multipliedBy(0.7)
    }

    emotionStack.snp.makeConstraints {
      $0.top.equalTo(graphStackView.snp.bottom).offset(LayoutContants.defaultPadding)
      $0.leading.trailing.equalTo(graphStackView)
      $0.height.equalTo(self.snp.height).multipliedBy(0.2)
    }
  }
}
private extension GraphView {
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
