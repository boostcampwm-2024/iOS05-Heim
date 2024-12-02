//
//  BarView.swift
//  Presentation
//
//  Created by 김미래 on 11/21/24.
//

import Domain
import UIKit

final class BarView: UIView {
  // MARK: - Properties
  let contentView = UIView()
  let bar: UIView = UIView()
  let chart: Chart

  // MARK: - Initializer
  init(chart: Chart) {
    self.chart = chart
    super.init(frame: .zero)
    
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Methods
  func setupViews() {
    addSubview(contentView)
    addSubview(bar)
    bar.backgroundColor = setBarColor(emotion: chart.emotion)
    
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    bar.snp.makeConstraints {
      $0.bottom.equalTo(contentView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(contentView.snp.height).multipliedBy(chart.value)
    }
  }

  func setBarColor(emotion: Emotion) -> UIColor {
    switch emotion {
    case .sadness:
      return .darkGray
    case .happiness:
      return .heimYellow
    case .angry:
      return .heimRed
    case .surprise:
      return .heimViolet
    case .fear:
      return .heimBlack
    case .disgust:
      return .heimGreen
    case .neutral:
      return .whiteBlue
    case .none:
      return .clear
    }
  }
}
