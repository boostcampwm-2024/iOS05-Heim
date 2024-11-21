//
//  BarView.swift
//  Presentation
//
//  Created by 김미래 on 11/21/24.
//

import UIKit

struct Chart {
  var value: Double
  var color: UIColor

  init(value: Double, color: UIColor) {
    self.value = value
    self.color = color
  }
}

final class BarView: UIView {
  let contentView: UIView = {
    let view = UIView()
    return view
  }()

  let bar: UIView = {
    let view = UIView()
    return view
  }()

  let chart: Chart

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(chart: Chart) {
    self.chart = chart
    super.init(frame: .zero)
    setUP()
  }

  func setUP() {
    addSubview(contentView)
    addSubview(bar)
    bar.backgroundColor = chart.color
    contentView.snp.makeConstraints {
//      $0.height.equalTo(UIScreen.main.bounds.height * 0.2)
//      $0.width.equalTo((UIScreen.main.bounds.width - 128) / 8)
      $0.edges.equalToSuperview()
    }

    bar.snp.makeConstraints {
      $0.bottom.equalTo(contentView.snp.bottom)
      $0.leading.trailing.equalToSuperview() // 좌우 맞추기
      $0.height.equalTo(contentView.snp.height).multipliedBy(chart.value)
    }

  }
}
