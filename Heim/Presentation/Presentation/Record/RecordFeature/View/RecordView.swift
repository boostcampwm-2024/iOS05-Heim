//
//  RecordView.swift
//  Presentation
//
//  Created by 박성근 on 11/17/24.
//

import Lottie
import UIKit
import SnapKit

// MARK: - 현재 뷰에 존재하는 버튼들의 종류를 구분하기 위함
enum RecordViewButtonItem {
  case recordToggle
  case refresh
  case next
  case close
}

protocol RecordViewDelegate: AnyObject {
  func buttonDidTap(
    _ recordingView: RecordView,
    _ item: RecordViewButtonItem
  )
}

final class RecordView: UIView {
  // MARK: - Properties
  weak var delegate: RecordViewDelegate?
  
  private var recordingButtons: [UIButton] = []
  
  // MARK: - UI Components
  private let closeButton: UIButton = {
    let button = UIButton()
    button.setImage(.xmark, for: .normal)
    button.tintColor = .white
    button.backgroundColor = .secondary
    button.layer.cornerRadius = LayoutConstants.closeButtonSize / 2
    return button
  }()
  
  private let microphoneAnimation: LottieAnimationView = {
    let bundle = Bundle(for: RecordView.self)
    let animation = LottieAnimation.named("microphone", bundle: bundle)
    let animationView = LottieAnimationView(animation: animation)
    animationView.contentMode = .scaleAspectFit
    animationView.loopMode = .loop
    return animationView
  }()
  
  private let timeLabel: UILabel = {
    let label = UILabel()
    label.text = "00:00"
    label.font = .regularFont(ofSize: LayoutConstants.timeLabelFontSize)
    label.textColor = .white
    return label
  }()
  
  private let buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.spacing = LayoutConstants.buttonStackSpacing
    return stackView
  }()
  
  private let playButton: UIButton = {
    let button = UIButton()
    button.setImage(.playFill, for: .normal)
    button.tintColor = .white
    return button
  }()
  
  private let refreshButton: UIButton = {
    let button = UIButton()
    button.setImage(.arrowClockwise, for: .normal)
    button.tintColor = .white
    return button
  }()
  
  private let nextButton: UIButton = {
    let button = UIButton()
    button.setTitle("오늘의 감정 분석하기!", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .boldFont(ofSize: LayoutConstants.buttonLabelFontSize)
    button.backgroundColor = .primary
    button.layer.cornerRadius = LayoutConstants.nextButtonCornerRadius
    return button
  }()
  
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
  
  func updatePlayButtonImage(isPlaying: Bool) {
    if isPlaying {
      playButton.setImage(.stopFill, for: .normal)
      microphoneAnimation.play()
    } else {
      playButton.setImage(.playFill, for: .normal)
      microphoneAnimation.stop()
    }
  }
  
  func updateTimeLabel(text: String) {
    timeLabel.text = text
  }
  
  func updateNextButton(isEnabled: Bool) {
    nextButton.isEnabled = isEnabled
    nextButton.backgroundColor = isEnabled ? .primary : .primaryTransparent
  }
}

private extension RecordView {
  // MARK: - Setup
  private func setupViews() {
    [closeButton, microphoneAnimation, timeLabel, buttonStackView, nextButton].forEach {
      addSubview($0)
    }
    
    [playButton, refreshButton].forEach {
      buttonStackView.addArrangedSubview($0)
    }
  }
  
  private func setupLayoutConstraints() {
    // MARK: - 스크린 높이를 가져온다.
    let screenHeight = UIApplication.screenHeight
    
    closeButton.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide.snp.top).offset(LayoutConstants.topPadding)
      $0.trailing.equalToSuperview().offset(-LayoutConstants.horizontalPadding)
      $0.width.height.equalTo(LayoutConstants.closeButtonSize)
    }
    
    microphoneAnimation.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalToSuperview().offset(screenHeight * LayoutConstants.microphoneAnimationImageTopRatio)
      $0.width.height.equalTo(LayoutConstants.microphoneAnimationImageSize)
    }
    
    timeLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(microphoneAnimation.snp.bottom).offset(screenHeight * LayoutConstants.timeLabelTopRatio)
    }
    
    buttonStackView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(timeLabel.snp.bottom).offset(LayoutConstants.buttonStackTopOffset)
    }
    
    [playButton, refreshButton].forEach {
      $0.snp.makeConstraints {
        $0.width.height.equalTo(LayoutConstants.controlButtonSize)
      }
    }
    
    nextButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(LayoutConstants.horizontalPadding)
      $0.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(-LayoutConstants.bottomPadding)
      $0.height.equalTo(LayoutConstants.nextButtonHeight)
    }
  }
  
  private func setupActions() {
    closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
    nextButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
  }
  
  // MARK: - Actions
  @objc private func closeButtonTapped() {
    delegate?.buttonDidTap(self, .close)
  }
  
  @objc private func playButtonTapped() {
    delegate?.buttonDidTap(self, .recordToggle)
  }
  
  @objc private func refreshButtonTapped() {
    delegate?.buttonDidTap(self, .refresh)
  }
  
  @objc private func nextButtonTapped() {
    delegate?.buttonDidTap(self, .next)
  }
}

// MARK: - LayoutConstants
private extension RecordView {
  enum LayoutConstants {
    // Button sizes
    static let closeButtonSize: CGFloat = 30
    static let controlButtonSize: CGFloat = 24
    static let nextButtonHeight: CGFloat = 50
    
    // Corner radius
    static let nextButtonCornerRadius: CGFloat = 16
    static let closeButtonCornerRadius: CGFloat = closeButtonSize / 2
    
    // Padding & Offset
    static let topPadding: CGFloat = 16
    static let horizontalPadding: CGFloat = 16
    static let bottomPadding: CGFloat = 16
    static let buttonStackTopOffset: CGFloat = 16
    static let buttonStackSpacing: CGFloat = 36
    
    // Image
    static let microphoneAnimationImageSize: CGFloat = 256
    
    // Screen ratio
    static let microphoneAnimationImageTopRatio: CGFloat = 0.2
    static let timeLabelTopRatio: CGFloat = 0.07
    
    // Font size
    static let timeLabelFontSize: CGFloat = 30
    static let buttonLabelFontSize: CGFloat = 18
  }
}
