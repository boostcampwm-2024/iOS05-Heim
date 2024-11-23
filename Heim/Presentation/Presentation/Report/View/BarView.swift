//
//  BarView.swift
//  Presentation
//
//  Created by 김미래 on 11/21/24.
//

import UIKit

// 그래프의 막대 부분
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
    setupViews()
  }

  func setupViews() {
    addSubview(contentView)
    addSubview(bar)
    bar.backgroundColor = chart.color
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    bar.snp.makeConstraints {
      $0.bottom.equalTo(contentView.snp.bottom)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(contentView.snp.height).multipliedBy(chart.value)
    }
  }
}
