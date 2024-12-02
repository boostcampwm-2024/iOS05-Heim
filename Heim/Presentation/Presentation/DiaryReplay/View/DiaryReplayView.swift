//
//  DiaryReplayView.swift
//  Presentation
//
//  Created by 정지용 on 11/28/24.
//

import UIKit
import SnapKit

// MARK: - 현재 뷰에 존재하는 버튼들의 종류를 구분하기 위함
enum DiaryReplayViewButtonItem {
  case replayToggle
  case refresh
}

protocol DiaryReplayViewDelegate: AnyObject {
  func buttonDidTap(
    _ diaryReplayView: DiaryReplayView,
    _ item: DiaryReplayViewButtonItem
  )
}

final class DiaryReplayView: UIView {
  // MARK: - Properties
  weak var delegate: DiaryReplayViewDelegate?
  private let visualizerView: VisualizerView
  
  private let descriptionLabel: CommonLabel = {
    let label = CommonLabel(font: .bold, size: LayoutConstants.descriptionLabelFontSize)
    return label
  }()
  
  // MARK: - UI Components
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
  
  // MARK: - Initialize
  init(
    visualizerView: VisualizerView,
    userName: String
  ) {
    self.visualizerView = visualizerView
    super.init(frame: .null)
    setupUserName(userName: userName)
    setupViews()
    setupLayoutConstraints()
    setupActions()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func updatePlayButtonImage(isPlaying: Bool) {
    playButton.setImage(isPlaying ? .stopFill : .playFill, for: .normal)
  }
  
  func updateTimeLabel(text: String) {
    timeLabel.text = text
  }
}

private extension DiaryReplayView {
  // MARK: - Setup
  private func setupUserName(userName: String) {
    self.descriptionLabel.text = "하임이가 \(userName)님의 목소리를 가지고 왔어요!"
  }
  
  private func setupViews() {
    [descriptionLabel, visualizerView, timeLabel, buttonStackView].forEach {
      addSubview($0)
    }
    
    [playButton, refreshButton].forEach {
      buttonStackView.addArrangedSubview($0)
    }
  }
  
  private func setupLayoutConstraints() {
    let screenHeight = UIApplication.screenHeight
    
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide).offset(LayoutConstants.topPadding)
      $0.leading.equalToSuperview().offset(LayoutConstants.horizontalPadding)
      $0.trailing.equalToSuperview().inset(LayoutConstants.horizontalPadding)
    }
    
    visualizerView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(
        screenHeight * LayoutConstants.microphoneAnimationImageTopRatio
      )
      $0.width.height.equalTo(LayoutConstants.microphoneAnimationImageSize)
    }
    
    timeLabel.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.top.equalTo(visualizerView.snp.bottom).offset(screenHeight * LayoutConstants.timeLabelTopRatio)
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
  }
  
  private func setupActions() {
    playButton.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
    refreshButton.addTarget(self, action: #selector(refreshButtonTapped), for: .touchUpInside)
  }
  
  // MARK: - Actions
  @objc
  private func playButtonTapped() {
    delegate?.buttonDidTap(self, .replayToggle)
  }
  
  @objc
  private func refreshButtonTapped() {
    delegate?.buttonDidTap(self, .refresh)
  }
}

// MARK: - LayoutConstants
private extension DiaryReplayView {
  enum LayoutConstants {
    // Button sizes
    static let controlButtonSize: CGFloat = 24
    static let nextButtonHeight: CGFloat = 50
    
    // Corner radius
    static let nextButtonCornerRadius: CGFloat = 16
    
    // Padding & Offset
    static let topPadding: CGFloat = 16
    static let horizontalPadding: CGFloat = 16
    static let bottomPadding: CGFloat = 16
    static let buttonStackTopOffset: CGFloat = 16
    static let buttonStackSpacing: CGFloat = 36
    
    // Image
    static let microphoneAnimationImageSize: CGFloat = 256
    
    // Screen ratio
    static let microphoneAnimationImageTopRatio: CGFloat = 0.1
    static let timeLabelTopRatio: CGFloat = 0.07
    
    // Font size
    static let timeLabelFontSize: CGFloat = 30
    static let buttonLabelFontSize: CGFloat = 18
    static let descriptionLabelFontSize: CGFloat = 20
  }
}
