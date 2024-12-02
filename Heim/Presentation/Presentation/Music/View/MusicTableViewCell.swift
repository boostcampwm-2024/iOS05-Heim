//
//  MusicTableViewCell.swift
//  Presentation
//
//  Created by 김미래 on 11/25/24.
//

import UIKit

protocol MusicTableViewCellDelegate: AnyObject {
  func playButtonDidTap(isrc: String?)
  func pauseButtonDidTap()
}

final class MusicTableViewCell: UITableViewCell {

  weak var delegate: MusicTableViewCellDelegate?
  var isrc: String?
  private let albumImage: UIImageView = {
    let view = UIImageView()
    view.layer.cornerRadius = LayoutConstants.cornerRadius
    view.backgroundColor = .gray
    view.layer.shadowPath = UIBezierPath(roundedRect: view.bounds, cornerRadius: view.layer.cornerRadius).cgPath
    view.layer.shadowColor = UIColor.gray.cgColor
    view.layer.shadowOffset = CGSize(width: LayoutConstants.shadowOffsetWidth,
                                     height: LayoutConstants.shadowOffsetHeight)
    view.layer.shadowRadius = LayoutConstants.shadowRadius
    view.layer.shadowOpacity = LayoutConstants.shadowOpacity
    return view
  }()

  private let titleLabel = CommonLabel(text: "제목", font: .regular, size: LayoutConstants.titleLabel, textColor: .black)

  private let subLabel = CommonLabel(text: "부제목",font: .regular, size: LayoutConstants.bodyThree, textColor: .black)

  private let playButton: UIButton = CommonRectangleButton(title: "듣기", fontStyle: .regularFont(ofSize: LayoutConstants.bodyThree), backgroundColor: .violet, radius: LayoutConstants.cornerRadius)
  
  // MARK: - Initializer
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupViews()
    setupLayoutconstraints()
    playButton.addTarget(self, action: #selector(buttondidTap), for: .touchUpInside)
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
  func configure(imageData: Data?,
                 titleText: String,
                 subTitle: String,
                 track: String) {
    if let imageData {
      albumImage.image = UIImage(data: imageData)
    }

    contentView.backgroundColor = .clear
    titleLabel.text = titleText
    subLabel.text = subTitle
    isrc = track
  }

  @objc func buttondidTap() {
    if playButton.currentTitle == "멈춤" {
      delegate?.pauseButtonDidTap()
    } else {
      delegate?.playButtonDidTap(isrc: isrc)
    }
  }

  func updatePlayButton(isPlaying: Bool) {
    playButton.setTitle(isPlaying ? "멈춤" : "듣기", for: .normal)
  }
}

private extension MusicTableViewCell {
  enum LayoutConstants {
//    static let albumImageSize: CGFloat = 80
    static let albumImageSize: CGFloat = UIApplication.screenHeight * 0.1
    static let defaultPadding: CGFloat = 16
    static let titleThree: CGFloat = 20
    static let titleLabel: CGFloat = 20
    static let bodyThree: CGFloat = 12
    static let labelTop: CGFloat = 4
    static let playButtonTop: CGFloat = 4
    static let labelRightPadding: CGFloat = 8
    static let playButtonWidth: CGFloat = 0.2
    static let cornerRadius: CGFloat = 13
    static let shadowOffsetHeight: CGFloat = 5
    static let shadowOffsetWidth: CGFloat = 0
    static let shadowRadius: CGFloat = 4
    static let shadowOpacity: Float = 0.7
  }

  func setupViews() {
    backgroundColor = .clear
    selectionStyle = .none
    titleLabel.sizeToFit()
    subLabel.sizeToFit()
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
      $0.trailing.equalTo(contentView).inset(LayoutConstants.defaultPadding) // Right
      $0.height.equalTo(titleLabel.frame.height)

    }

    subLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(0)
      $0.height.equalTo(subLabel.frame.height)
      $0.leading.equalTo(titleLabel.snp.leading)
      $0.trailing.equalTo(contentView).inset(LayoutConstants.defaultPadding)
    }

    playButton.snp.makeConstraints {
      $0.top.equalTo(subLabel.snp.bottom).offset(8)
      $0.leading.equalTo(subLabel.snp.leading)
      $0.width.equalTo(contentView.snp.width).multipliedBy(LayoutConstants.playButtonWidth)
      $0.bottom.equalTo(albumImage.snp.bottom)
    }
  }
}
