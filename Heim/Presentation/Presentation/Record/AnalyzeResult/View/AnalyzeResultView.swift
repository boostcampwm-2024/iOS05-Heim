//
//  AnalyzeResultView.swift
//  Presentation
//
//  Created by 박성근 on 11/27/24.
//

import UIKit
import SnapKit

enum AnalyzeResultViewButtonItem {
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
    label.textColor = .white
    return label
  }()
  
  private let descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = .regularFont(ofSize: LayoutConstants.title2)
    label.textColor = .white
    return label
  }()
  
  private let characterImageView: UIImageView = {
    let imageView = UIImageView()
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
    name: String,
    description: String,
    content: String
  ) {
    titleLabel.text = "오늘 \(name)님의 기분"
    characterImageView.image = UIImage.configureImage(emotion: description)
    descriptionLabel.text = String.recordConfigureDescription(emotion: description)
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
    
    [homeButton].forEach {
      buttonStackView.addArrangedSubview($0)
    }
  }
  
  func setupActions() {
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
    
    [homeButton].forEach {
      $0.snp.makeConstraints {
        $0.height.equalTo(LayoutConstants.buttonHeight)
      }
    }
  }
  
  // MARK: - Action Methods, 해당 부분도 DiaryDetailView에서의 작업과 같은데, 같이 사용할 수 있도록 수정하는 것이 좋아보임.
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
