//
//  CommonLabel.swift
//  Presentation
//
//  Created by 한상진 on 11/7/24.
//

import UIKit

final class CommonLabel: UILabel {
  // MARK: - Properties
  enum HeimFontStyle {
    case bold, regular
  }
  
  // MARK: - Initializer
  init(
    text: String = "", 
    textAlignment: NSTextAlignment = .left,
    font: HeimFontStyle,
    size: CGFloat,
    textColor: UIColor = .white
  ) {
    super.init(frame: .zero)
    
    self.text = text
    self.textAlignment = textAlignment 
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
  
  func setupLineSpacing() {
    guard isLineBroken() else { return }
    
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = font.lineHeight * 0.5
    paragraphStyle.alignment = textAlignment
    
    let attributedString = NSAttributedString(
      string: text ?? "",
      attributes: [
        .paragraphStyle: paragraphStyle,
        .font: font ?? UIFont()
      ]
    )
    
    attributedText = attributedString
  }
  
  func updateTextKeepingAttributes(_ newText: String) {
    guard let currentAttributedText = attributedText else {
      text = newText
      return
    }
    
    let newAttributedText = NSMutableAttributedString(attributedString: currentAttributedText)
    newAttributedText.mutableString.setString(newText)
    attributedText = newAttributedText
  }
}

private extension CommonLabel {
  func isLineBroken() -> Bool {
    let size = CGSize(width: frame.width, height: .greatestFiniteMagnitude)
    let neededSize = sizeThatFits(size)
    
    return neededSize.height > frame.height
  }
}
