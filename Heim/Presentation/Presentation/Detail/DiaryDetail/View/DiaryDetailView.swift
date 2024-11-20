//
//  DiaryDetailView.swift
//  Presentation
//
//  Created by 박성근 on 11/19/24.
//

import UIKit
import SnapKit

// MARK: - 현재 뷰에 존재하는 버튼들의 종류를 구분하기 위함
enum DiaryDetailViewButtonItem {
  case musicRecomendation
  case heimReply
  case replayVoice
}

protocol DiaryDetailViewDelegate: AnyObject {
  func buttonDidTap(
    _ recordingView: DiaryDetailView,
    _ item: DiaryDetailViewButtonItem
  )
}

final class DiaryDetailView: UIView {
  // MARK: - Properties
  weak var delegate: DiaryDetailViewDelegate?
  private let textArea = CommonTextAreaView()
  
  private lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    return scrollView
  }()
  
  private let contentView = UIView()
  
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.font = .boldFont(ofSize: 28)
    label.textColor = .white
    return label
  }()
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .regularFont(ofSize: 20)
    label.textColor = .white
    return label
  }()
  
  private let characterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "splashRabbit")
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private lazy var buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 16
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private lazy var musicRecomendationButton: UIButton = {
    let button = UIButton()
    button.setTitle("추천 음악 감상하기", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .primary
    button.layer.cornerRadius = 16
    button.addTarget(self, action: #selector(musicRecomendationButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var heimReplyButton: UIButton = {
    let button = UIButton()
    button.setTitle("하임이의 답장 보러가기", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .primary
    button.layer.cornerRadius = 16
    button.addTarget(self, action: #selector(heimReplyButtonTapped), for: .touchUpInside)
    return button
  }()
  
  private lazy var replayVoiceButton: UIButton = {
    let button = UIButton()
    button.setTitle("나의 이야기 다시듣기", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.backgroundColor = .primary
    button.layer.cornerRadius = 16
    button.addTarget(self, action: #selector(replayVoiceButtonTapped), for: .touchUpInside)
    return button
  }()

  // MARK: - Initialize
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupLayoutConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public Methods
  func configure(date: String, description: String, content: String) {
    dateLabel.text = date
    descriptionLabel.text = description
    textArea.setText(content)
  }
}

// MARK: - Layout
private extension DiaryDetailView {
  func setupViews() {
    addSubview(scrollView)
    scrollView.addSubview(contentView)
    
    [dateLabel, descriptionLabel, characterImageView, textArea, buttonStackView].forEach {
      contentView.addSubview($0)
    }
    
    [musicRecomendationButton, heimReplyButton, replayVoiceButton].forEach {
      buttonStackView.addArrangedSubview($0)
    }
  }

  func setupLayoutConstraints() {
    scrollView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalToSuperview()
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(16)
      $0.leading.equalToSuperview().offset(16)
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(dateLabel.snp.bottom).offset(16)
      $0.leading.equalTo(dateLabel)
    }
    
    characterImageView.snp.makeConstraints {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
      $0.size.equalTo(160)
    }
    
    textArea.snp.makeConstraints {
      $0.top.equalTo(characterImageView.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview().inset(16)
    }
    
    buttonStackView.snp.makeConstraints {
      $0.top.equalTo(textArea.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview().inset(16)
      $0.bottom.equalToSuperview().offset(-16)
    }
    
    [musicRecomendationButton, heimReplyButton, replayVoiceButton].forEach {
      $0.snp.makeConstraints {
        $0.height.equalTo(50)
      }
    }
  }
}

// MARK: - Actions
private extension DiaryDetailView {
  @objc func musicRecomendationButtonTapped() {
    delegate?.buttonDidTap(self, .musicRecomendation)
  }
  
  @objc func heimReplyButtonTapped() {
    delegate?.buttonDidTap(self, .heimReply)
  }
  
  @objc func replayVoiceButtonTapped() {
    delegate?.buttonDidTap(self, .replayVoice)
  }
}
