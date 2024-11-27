//
//  ReplyViewController.swift
//  Presentation
//
//  Created by 정지용 on 11/27/24.
//

import Domain
import SnapKit
import UIKit

final class ReplyViewController: UIViewController {
  // MARK: - UIComponents
  private let scrollView = UIScrollView()
  
  private let backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = .background
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .left
    label.textColor = .white
    label.backgroundColor = .clear
    return label
  }()
  
  private let contentLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textAlignment = .left
    label.textColor = .white
    label.backgroundColor = .clear
    return label
  }()
  
  // MARK: - Properties
  private let diary: Diary
  
  // MARK: - Initializer
  init(diary: Diary) {
    self.diary = diary
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupView()
    setupLabel()
    setLineSpacing()
    setupLayoutConstraints()
  }
}

// MARK: - Private Methods
private extension ReplyViewController {
  func setupView() {
    view.addSubview(backgroundImageView)
    view.addSubview(scrollView)
    [titleLabel, contentLabel].forEach { scrollView.addSubview($0) }
  }
  
  func setupLayoutConstraints() {
    scrollView.snp.makeConstraints {
      $0.edges.equalTo(view.safeAreaLayoutGuide)
    }
    
    backgroundImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalTo(scrollView.snp.top).offset(LayoutConstants.defaultPadding)
      $0.leading.trailing.equalToSuperview().inset(LayoutConstants.defaultPadding)
    }
    
    contentLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(LayoutConstants.contentOffset)
      $0.leading.trailing.bottom.equalToSuperview().inset(LayoutConstants.defaultPadding)
      $0.width.equalTo(scrollView.frameLayoutGuide.snp.width).offset(-2 * LayoutConstants.defaultPadding)
    }
  }
  
  func setupLabel() {
    titleLabel.text = LayoutConstants.titleText
    contentLabel.text = diary.emotionReport.text
    titleLabel.font = UIFont.boldFont(ofSize: LayoutConstants.title3)
  }
  
  func setLineSpacing() {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = LayoutConstants.lineHeightMultiple
    
    let attributedString = NSAttributedString(
      string: contentLabel.text ?? "",
      attributes: [
        .paragraphStyle: paragraphStyle,
        .font: UIFont.regularFont(ofSize: LayoutConstants.body1)
      ]
    )
    contentLabel.attributedText = attributedString
  }
  
  enum LayoutConstants {
    static let titleText: String = "하임이가 답장을 보냈어요!"
    static let title3: CGFloat = 20
    static let body1: CGFloat = 16
    static let defaultPadding: CGFloat = 16
    static let contentOffset: CGFloat = 44
    static let lineHeightMultiple: CGFloat = 1.3
  }
}
