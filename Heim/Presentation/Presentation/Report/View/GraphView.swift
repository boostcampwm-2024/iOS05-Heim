//
//  GraphView.swift
//  Presentation
//
//  Created by 김미래 on 11/22/24.
//

import Domain
import UIKit

final class GraphView: UIView {
  // MARK: - Properties
  private let graphStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = LayoutConstants.stackViewPadding
    stackView.distribution = .fillEqually
    return stackView
  }()

  private let emotionStack: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = LayoutConstants.stackViewPadding
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private let underLineView: UIView = {
    let view = UIView()
    view.backgroundColor = .white.withAlphaComponent(0.5)
    return view
  }()

  // MARK: - Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupLayoutConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Methods
  func configureChart(_ emotionCountDictionary: [Emotion: Int]) {
    graphStackView.arrangedSubviews.forEach {
      $0.removeFromSuperview()
    }
    
    emotionStack.arrangedSubviews.forEach {
      $0.removeFromSuperview()
    }
    
    var charts: [Chart] = []
    let totalCount = emotionCountDictionary.values.reduce(0, +)
    guard totalCount > 0 else { return }
    
    emotionCountDictionary.forEach {
      charts.append(Chart(
        value: CGFloat($0.value) / CGFloat(totalCount), 
        emotion: $0.key
      ))
    }
    charts.sort { $0.value > $1.value }
    
    charts.forEach {
      graphStackView.addArrangedSubview(BarView(chart: $0))
      emotionStack.addArrangedSubview(HeimEmojiView(emotion: $0.emotion))
    }
  }
}

// MARK: - Layout
private extension GraphView {
  func setupViews() {
    addSubview(graphStackView)
    addSubview(underLineView)
    addSubview(emotionStack)
  }

  func setupLayoutConstraints() {
    graphStackView.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.leading.trailing.equalToSuperview()
      $0.height.equalToSuperview().multipliedBy(LayoutConstants.graphViewHeightRatio)
    }
    
    underLineView.snp.makeConstraints {
      $0.top.equalTo(graphStackView.snp.bottom)
      $0.height.equalTo(LayoutConstants.underLineView)
      $0.leading.trailing.equalTo(graphStackView)
    }

    emotionStack.snp.makeConstraints {
      $0.top.equalTo(graphStackView.snp.bottom).offset(LayoutConstants.emotionPadding)
      $0.leading.trailing.equalTo(graphStackView)
      $0.height.equalTo(emotionStack.snp.width).multipliedBy(LayoutConstants.emotionViewHeightRatio)
    }
  }
  
  enum LayoutConstants {
    static let stackViewPadding: CGFloat = 8
    static let emotionPadding: CGFloat = 5
    static let underLineView: CGFloat = 2
    static let graphViewHeightRatio: CGFloat = 0.838
    static let emotionViewHeightRatio: CGFloat = 0.113
  }
}
