//
//  HeimLabel.swift
//  Presentation
//
//  Created by 한상진 on 11/7/24.
//

import UIKit

final class HeimLabel: UILabel {
  
  // MARK: - Properties
  enum HeimFontStyle {
    case bold, regular
  }
  
  // MARK: - Initializer
  init(
    text: String = "", 
    font: HeimFontStyle,
    size: CGFloat,
    textColor: UIColor = .white
  ) {
    super.init(frame: .zero)
    
    self.text = text
    self.textColor = textColor
    self.numberOfLines = 0
    
    switch font {
    case .bold: self.font = .boldFont(ofSize: size)
    case .regular: self.font = .regularFont(ofSize: size)
    }
  }
  
  required init?(coder: NSCoder) {
    super.init(frame: .zero)
  }
}
