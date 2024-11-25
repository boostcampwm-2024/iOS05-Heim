//
//  MusicTableViewCell.swift
//  Presentation
//
//  Created by 김미래 on 11/25/24.
//

import UIKit

class MusicTableViewCell: UITableViewCell {

  private let albumImage = UIImageView()
  private let titleLabel: CommonLabel = {
    let label = CommonLabel(font: .regular, size: LayoutConstants.titleLabel)
    label.text = "제목"
    return label
  }()

  private let subLabel: CommonLabel = {
    let label = CommonLabel(font: .regular, size: LayoutConstants.bodyThree)
    return label
  }()

  private let playButton: UIButton = {
    let button = UIButton()
    button.setTitle("듣기", for: .normal)
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
  func configure(titleText: String, subTitle: String) {
    titleLabel.text = titleText
    subLabel.text = subTitle
  }
}

private extension MusicTableViewCell {
  enum LayoutConstants {
    static let defaultPadding: CGFloat = 16
    static let titleThree: CGFloat = 20
    static let titleLabel: CGFloat = 20
    static let bodyThree: CGFloat = 12
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
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(albumImage.snp.top)
      $0.leading.equalTo(albumImage.snp.trailing).offset(12)
    }

    subLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(8)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.right.equalToSuperview().offset(8)
    }

    playButton.snp.makeConstraints {
      $0.top.equalTo(subLabel.snp.bottom).offset(LayoutConstants.defaultPadding)
      $0.leading.equalTo(subLabel.snp.leading)
    }
  }
}
