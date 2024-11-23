//
//  Chart.swift
//  Presentation
//
//  Created by 김미래 on 11/22/24.
//

import UIKit
// 막대그래프의 막대의 비율을 계산하는 모델, value = 해당 감정의 갯수/totalCount
struct Chart {
  // MARK: Properties
  var value: Double
  var color: UIColor

  // MARK: - Initializer
  init(value: Double, color: UIColor) {
    self.value = value
    self.color = color
  }
}
