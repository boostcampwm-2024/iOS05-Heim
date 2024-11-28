//
//  EmotionAnalyzeView.swift
//  Presentation
//
//  Created by 박성근 on 11/23/24.
//

import UIKit
import Lottie
import SnapKit

protocol EmotionAnalyzeViewDelegate: AnyObject {
  func buttonDidTap(
    _ emotionAnalyzeView: EmotionAnalyzeView
  )
}

final class EmotionAnalyzeView: UIView {
  // MARK: - Properties
  private let screenHeight = UIApplication.screenHeight
  weak var delegate: EmotionAnalyzeViewDelegate?
  
  private let characterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = .recordRabbit
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let messageAnimation: LottieAnimationView = {
    let bundle = Bundle(for: RecordView.self)
    let animation = LottieAnimation.named("message", bundle: bundle)
    let animationView = LottieAnimationView(animation: animation)
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .loop
    return animationView
  }()
  
  private let descriptionLabel: CommonLabel = CommonLabel(
    font: .regular,
    size: LayoutConstants.body1
  )
  
  private let nextButton: CommonRectangleButton = CommonRectangleButton(
    title: "분석 결과 확인하기!",
    fontStyle: .boldFont(ofSize: LayoutConstants.body1),
    backgroundColor: .primaryTransparent
  )
  
  // MARK: - Initialize
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupLayoutConstraints()
    setupActions()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - UI Logic Methods
  func updatedescriptionLabel(isAnalyzing: Bool) {
    if isAnalyzing {
      descriptionLabel.text = "하임이가 열심히 일기를 분석하고 있어요..."
    } else {
      descriptionLabel.text = "완료되었어요!"
    }
  }
  
  func updateNextButton(isAnalyzing: Bool) {
    // isAnalyzing이 false일 때(분석 완료) 버튼 활성화
    nextButton.isEnabled = !isAnalyzing
    
    if isAnalyzing {
      characterImageView.isHidden = true
      nextButton.backgroundColor = .primaryTransparent
      nextButton.setTitleColor(.gray, for: .disabled)
      messageAnimation.play()
    } else {
      nextButton.backgroundColor = .primary
      nextButton.setTitleColor(.white, for: .normal)
      messageAnimation.stop()
      messageAnimation.isHidden = true
      characterImageView.isHidden = false
    }
  }
}

// MARK: - Settings
private extension EmotionAnalyzeView {
  func setupViews() {
    [characterImageView, messageAnimation, descriptionLabel, nextButton].forEach {
      addSubview($0)
    }
  }
  
  func setupLayoutConstraints() {
    characterImageView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(screenHeight * LayoutConstants.messageAnimationTopRatio)
      $0.width.height.equalTo(LayoutConstants.characterImageSize)
    }
    
    messageAnimation.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(screenHeight * LayoutConstants.messageAnimationTopRatio)
      $0.width.height.equalTo(LayoutConstants.characterImageSize)
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(messageAnimation.snp.bottom).offset(LayoutConstants.paddingInset)
    }
    
    nextButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(LayoutConstants.paddingInset)
      $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-LayoutConstants.paddingInset)
      $0.height.equalTo(LayoutConstants.buttonHeight)
    }
  }
  
  func setupActions() {
    nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
  }
  
  @objc private func nextButtonTapped() {
    delegate?.buttonDidTap(self)
  }
}

// MARK: - Constants
private extension EmotionAnalyzeView {
  enum LayoutConstants {
    static let body1: CGFloat = 16
    
    static let buttonHeight: CGFloat = 50
    static let characterImageSize: CGFloat = 250
    
    static let messageAnimationTopRatio: CGFloat = 0.3
    static let paddingInset: CGFloat = 16
  }
}
