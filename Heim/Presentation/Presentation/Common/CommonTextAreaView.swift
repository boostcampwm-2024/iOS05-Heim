//
//  CommonTextAreaView.swift
//  Presentation
//
//  Created by 정지용 on 11/7/24.
//

import UIKit
import SnapKit

/// CommonTextArea는 커스텀한 배경 색상과 오버레이를 갖춘 `UIView`의 서브클래스입니다.
/// 텍스트를 보여주기 위한 `UILabel`을 포함하며,  텍스트에 따라 가변적으로 높이가 변화하도록 설계되었습니다.
/// 필요에 따라 생성 시 최소 높이를 설정할 수 있습니다.
///
/// UILabel에서 사용될 text를 지정하기 위해 `setText(_ text: String)`를 구현했습니다.
/// `minHeight`을 사용하며, Constraint를 설정하는 경우를 위해 `requiredHeight()`를 구현했고, 자세한 부분은 해당 메소드의 코멘트를 확인해주세요.
final class CommonTextAreaView: UIView {
  // MARK: - Properties
  private let gradientLayer = CAGradientLayer()
  private let whiteOverlayLayer = CALayer()
  private let minHeight: CGFloat
  
  private let textLabel: UILabel = {
    let textLabel = UILabel()
    textLabel.numberOfLines = 0
    textLabel.textAlignment = .left
    textLabel.textColor = .black
    textLabel.backgroundColor = .clear
    return textLabel
  }()
  
  // MARK: - Initializer
  public init(
    min height: CGFloat = 0
  ) {
    self.minHeight = height
    super.init(frame: .zero)
    setupLayers()
    setupViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Methods
  override func layoutSubviews() {
    super.layoutSubviews()
    
    gradientLayer.frame = bounds
    whiteOverlayLayer.frame = bounds
  }
  
  /// 텍스트를 설정하는 메서드입니다.
  ///
  /// - Parameter text: 표시할 텍스트
  func setText(_ text: String) {
    textLabel.text = text
    setLineSpacing()
  }
  
  /// 전체 텍스트를 화면에 표시하기 위해 높이를 계산합니다.
  /// Constraint를 지정할 때 사용하면 됩니다.
  ///
  /// Example:
  /// ```swift
  /// // SnapKit 사용 시
  /// make.height.equalTo(commonTextView.requiredHeight())
  /// ```
  ///
  /// - Returns: `minHeight`과 화면에 Text를 완전히 보여주기 위한 크기를 비교하여 CGFloat 값을 반환합니다.
  func requiredHeight() -> CGFloat {
    let size = CGSize(width: textLabel.bounds.width, height: .infinity)
    let estimatedSize = textLabel.sizeThatFits(size)
    
    return max(minHeight, estimatedSize.height + 2 * Constants.labelPadding)
  }
}

// MARK: - Setup, Configuration UI
private extension CommonTextAreaView {
  func setupLayers() {
    gradientLayer.colors = [UIColor.white.cgColor, UIColor.secondary.cgColor]
    layer.addSublayer(gradientLayer)
    whiteOverlayLayer.backgroundColor = UIColor.white.withAlphaComponent(0.6).cgColor
    layer.addSublayer(whiteOverlayLayer)
  }
  
  func setupViews() {
    layer.cornerRadius = Constants.cornerRadius
    layer.masksToBounds = true
    setupLabel()
  }
  
  func setupLabel() {
    addSubview(textLabel)
    textLabel.font = UIFont.regularFont(ofSize: Constants.fontSize)
    
    textLabel.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(Constants.labelPadding)
    }
  }
}

// MARK: - Private Methods
private extension CommonTextAreaView {
  func setLineSpacing(
    lineHeightMultiple: CGFloat = 1.3
  ) {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = lineHeightMultiple
    
    let attributedString = NSAttributedString(
      string: textLabel.text ?? "",
      attributes: [
        .paragraphStyle: paragraphStyle,
        .font: textLabel.font ?? UIFont.systemFont(ofSize: 16)
      ]
    )
    
    textLabel.attributedText = attributedString
  }
}

// MARK: - Constants
extension CommonTextAreaView {
  private enum Constants {
    static let cornerRadius: CGFloat = 10
    static let labelPadding: CGFloat = 16
    static let fontSize: CGFloat = 16
  }
}
