//
//  Chart.swift
//  Presentation
//
//  Created by 김미래 on 11/22/24.
//

import UIKit

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
