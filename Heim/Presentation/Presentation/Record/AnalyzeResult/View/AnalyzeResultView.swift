//
//  AnalyzeResultView.swift
//  Presentation
//
//  Created by 박성근 on 11/27/24.
//

import UIKit
import SnapKit

// TODO: DiaryDetailView 내 버튼과 함께 사용하는 쪽으로 수정
enum AnalyzeResultViewButtonItem {
  case musicRecomendation
  case moveToHome
}

protocol AnalyzeResultViewDelegate: AnyObject {
  func buttonDidTap(
    _ recordingView: AnalyzeResultView,
    _ item: AnalyzeResultViewButtonItem
  )
}

final class AnalyzeResultView: UIView {
  // MARK: - Properties
  weak var delegate: AnalyzeResultViewDelegate?
  private let textArea = CommonTextAreaView()
  
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    return scrollView
  }()
  
  private let contentView = UIView()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.font = .regularFont(ofSize: LayoutConstants.title2)
    // TODO: 이름을 가져오는 기능이 구현되면 수정할 예정입니다.
    label.text = "오늘 성근님의 기분은"
    label.textColor = .white
    return label
  }()
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .regularFont(ofSize: LayoutConstants.title2)
    label.textColor = .white
    return label
  }()
  
  // TODO: 감정에 맞게 이미지 변경
  private let characterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = .angryIcon
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  private let buttonStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = LayoutConstants.padding
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private let musicRecomendationButton: CommonRectangleButton = {
    let button = CommonRectangleButton(
      title: "하임이가 추천하는 노래 듣기",
      fontStyle: .boldFont(ofSize: LayoutConstants.buttonLabelFontSize),
      titleColor: .white,
      backgroundColor: .primaryTransparent
    )
    return button
  }()
  
  private let homeButton: CommonRectangleButton = {
    let button = CommonRectangleButton(
      title: "메인 화면으로 이동하기",
      fontStyle: .boldFont(ofSize: LayoutConstants.buttonLabelFontSize),
      titleColor: .white,
      backgroundColor: .primaryTransparent
    )
    return button
  }()
  
  // MARK: - Initialize
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupActions()
    setupLayoutConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public Methods
  func configure(
    // TODO: name: String,
    description: String,
    content: String
  ) {
    // TODO: titleLabel.text = name
    descriptionLabel.text = description
    textArea.setText(content)
  }
}

// MARK: - Layout
private extension AnalyzeResultView {
  func setupViews() {
    addSubview(scrollView)
    scrollView.addSubview(contentView)
    
    [titleLabel, descriptionLabel, characterImageView, textArea, buttonStackView].forEach {
      contentView.addSubview($0)
    }
    
    [musicRecomendationButton, homeButton].forEach {
      buttonStackView.addArrangedSubview($0)
    }
  }
  
  func setupActions() {
    musicRecomendationButton.addTarget(self, action: #selector(musicRecomendationButtonTapped), for: .touchUpInside)
    homeButton.addTarget(self, action: #selector(homeButtonTapped), for: .touchUpInside)
  }
  
  func setupLayoutConstraints() {
    scrollView.snp.makeConstraints {
      $0.top.bottom.equalTo(safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
    
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
      $0.width.equalToSuperview()
      // TODO: Layout 다시 점검
      $0.height.greaterThanOrEqualToSuperview().priority(.low)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(LayoutConstants.padding)
      $0.centerX.equalToSuperview()
    }
    
    characterImageView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(LayoutConstants.padding)
      $0.centerX.equalToSuperview()
      $0.size.equalTo(LayoutConstants.characterImageSize)
    }
    
    descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(characterImageView.snp.bottom).offset(LayoutConstants.padding)
      $0.centerX.equalToSuperview()
    }
    
    textArea.snp.makeConstraints {
      $0.top.equalTo(descriptionLabel.snp.bottom).offset(LayoutConstants.padding)
      $0.leading.trailing.equalToSuperview().inset(LayoutConstants.padding)
    }
    
    buttonStackView.snp.makeConstraints {
      $0.top.equalTo(textArea.snp.bottom).offset(LayoutConstants.padding)
      $0.leading.trailing.equalToSuperview().inset(LayoutConstants.padding)
      $0.bottom.equalToSuperview().offset(-LayoutConstants.padding)
    }
    
    [musicRecomendationButton, homeButton].forEach {
      $0.snp.makeConstraints {
        $0.height.equalTo(LayoutConstants.buttonHeight)
      }
    }
  }
  
  // MARK: - Action Methods, 해당 부분도 DiaryDetailView에서의 작업과 같은데, 같이 사용할 수 있도록 수정하는 것이 좋아보임.
  @objc func musicRecomendationButtonTapped() {
    delegate?.buttonDidTap(self, .musicRecomendation)
  }
  
  @objc func homeButtonTapped() {
    delegate?.buttonDidTap(self, .moveToHome)
  }
}

private extension AnalyzeResultView {
  enum LayoutConstants {
    static let title2: CGFloat = 24
    
    static let characterImageSize: CGFloat = 160
    
    static let padding: CGFloat = 16
    static let buttonLabelFontSize: CGFloat = 18
    static let buttonHeight: CGFloat = 50
  }
}
