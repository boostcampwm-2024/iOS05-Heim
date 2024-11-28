//
//  CalendarCollectionViewCell.swift
//  Presentation
//
//  Created by 김미래 on 11/6/24.
//

import UIKit

final class CalendarCell: UICollectionViewCell {
  // MARK: - UI Components
  private let dateLabel = CommonLabel(font: .regular, size: LayoutContants.fontSize, textColor: .white)
  private let emojiView = UIImageView()

  // MARK: - Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
    setupViews()
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    dateLabel.text = ""
    dateLabel.textColor = .white
    emojiView.image = nil
    emojiView.backgroundColor = .clear
  }

  // MARK: - Methods
  func configure(_ dataSource: CalendarCellModel) {
    dateLabel.text = dataSource.day
    
    switch dataSource.emotion {
    case .sadness: emojiView.image = .sadIcon
    case .happiness: emojiView.image = .happyIcon
    case .angry: emojiView.image = .angryIcon
    case .surprise: emojiView.image = .surpriseIcon
    case .fear: emojiView.image = .fearIcon
    case .disgust: emojiView.image = .disgustIcon
    case .neutral: emojiView.image = .neutralIcon
    case .none: emojiView.image = nil
    }
    
    if dataSource.day.isEmpty || dataSource.emotion != .none {
      emojiView.backgroundColor = .clear
    } else {
      emojiView.backgroundColor = .whiteGray
    }
  }
  
  func updateDayLabelColor(_ color: UIColor) {
    dateLabel.textColor = color
  }
}

// MARK: - Private Extenion
private extension CalendarCell {
  private func setupViews() {
    emojiView.cornerRadius(radius: CGFloat(LayoutContants.cellWidth) / 2)
    contentView.addSubview(emojiView)
    contentView.addSubview(dateLabel)
    
    emojiView.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(emojiView.snp.width)
      $0.top.centerX.equalToSuperview()
    }
    
    dateLabel.snp.makeConstraints {
      $0.top.equalTo(emojiView.snp.bottom)
      $0.centerX.equalTo(emojiView)
      $0.bottom.equalToSuperview()
    }
  }
  
  enum LayoutContants {
    static let fontSize: CGFloat = 14
    static let collectionViewHorizontalPadding: CGFloat = 48
    static let cellWidth: Int = Int(UIApplication.screenWidth - Self.collectionViewHorizontalPadding) / 9
  }
}
