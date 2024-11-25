//
//  MusicTableViewCell.swift
//  Presentation
//
//  Created by 김미래 on 11/25/24.
//

import UIKit

final class MusicTableViewCell: UITableViewCell {

  private let albumImage: UIImageView = {
    let view = UIImageView()
    view.layer.cornerRadius = LayoutConstants.cornerRadius
    view.backgroundColor = .gray
    view.layer.shadowColor = UIColor.gray.cgColor
    view.layer.shadowOffset = CGSize(width: 0, height: 5)
    view.layer.shadowRadius = 4
    view.layer.shadowOpacity = 0.7
    return view
  }()

  private let titleLabel: CommonLabel = {
    let label = CommonLabel(font: .regular, size: LayoutConstants.titleLabel)
    label.textColor = .black
    label.text = "제목"
    return label
  }()

  private let subLabel: CommonLabel = {
    let label = CommonLabel(font: .regular, size: LayoutConstants.bodyThree)
    label.textColor = .black
    return label
  }()

  private let playButton: UIButton = {
    let text = "듣기"
    var configuration = UIButton.Configuration.tinted()
    configuration.baseForegroundColor = .white
    var container = AttributeContainer()
    container.font = .regularFont(ofSize: LayoutConstants.bodyThree)
    configuration.attributedTitle = AttributedString(text, attributes: container)

    let button = UIButton(configuration: configuration, primaryAction: nil)
    button.backgroundColor = .violet
    button.layer.masksToBounds = true
    button.layer.cornerRadius = LayoutConstants.cornerRadius

    return button
  }()

  // MARK: - Initializer
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    setupLayoutconstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - LifeCycle
  override func prepareForReuse() {
    super.prepareForReuse()
    albumImage.image = nil
    titleLabel.text = nil
    subLabel.text = nil
  }

  // MARK: - Methods
  // TODO: 파라미터에 앨범 이미지 추가
  func configure(titleText: String, subTitle: String, action: UIAction) {
    contentView.backgroundColor = .clear
    titleLabel.text = titleText
    subLabel.text = subTitle
    playButton.addAction(action, for: .touchUpInside)
  }
}

private extension MusicTableViewCell {
  enum LayoutConstants {
    static let albumImageSize: CGFloat = 80
    static let defaultPadding: CGFloat = 16
    static let titleThree: CGFloat = 20
    static let titleLabel: CGFloat = 20
    static let bodyThree: CGFloat = 12
    static let labelTop: CGFloat = 8
    static let labelRightPadding: CGFloat = 8
    static let playButtonWidth: CGFloat = 0.2
    static let cornerRadius: CGFloat = 15
  }

  func setupViews() {
    backgroundColor = .clear
    selectionStyle = .none

    contentView.addSubview(albumImage)
    contentView.addSubview(titleLabel)
    contentView.addSubview(subLabel)
    contentView.addSubview(playButton)
  }

  func setupLayoutconstraints() {
    albumImage.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview().inset(LayoutConstants.defaultPadding)
      $0.width.equalTo(LayoutConstants.albumImageSize)
      $0.height.equalTo(LayoutConstants.albumImageSize)
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(albumImage.snp.top)
      $0.leading.equalTo(albumImage.snp.trailing).offset(12)
    }

    subLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(LayoutConstants.labelTop)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.right.equalTo(contentView).offset(LayoutConstants.labelRightPadding)
    }

    playButton.snp.makeConstraints {
      $0.top.equalTo(subLabel.snp.bottom).offset(LayoutConstants.labelTop)
      $0.leading.equalTo(subLabel.snp.leading)
      $0.width.equalTo(contentView.snp.width).multipliedBy(LayoutConstants.playButtonWidth)
      $0.bottom.equalTo(albumImage.snp.bottom)
    }
  }
}
