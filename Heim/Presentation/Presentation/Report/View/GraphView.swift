//
//  GraphView.swift
//  Presentation
//
//  Created by 김미래 on 11/22/24.
//

import UIKit

final class GraphView: UIView {

  let emotionCharts: [Chart] =
  [Chart(value: 0.2, color: .red),
   Chart(value: 0.3, color: .blue),
   Chart(value: 0.3, color: .white),
   Chart(value: 0.1, color: .yellow),
   Chart(value: 0.18, color: .black),
   Chart(value: 0.4, color: .black),
   Chart(value: 0.3, color: .brown) ]

  private let graphStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 16
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

  }

  //  init(emotionCharts: [Chart]) {
  //    self.emotionCharts = emotionCharts
  //    super.init(frame: .zero)
  //  }

}

// MARK: - Layout
private extension GraphView {
  func setupViews() {
    addSubview(graphStackView)

  }

  func setupGraphStackView() {
    emotionCharts.forEach {
      let barView = BarView(chart: $0)
      graphStackView.addArrangedSubview(barView)
    }

    graphStackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
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
