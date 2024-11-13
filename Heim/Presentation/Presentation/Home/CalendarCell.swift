//
//  CalendarCollectionViewCell.swift
//  Presentation
//
//  Created by 김미래 on 11/6/24.
//

import UIKit

class CalendarCell: UICollectionViewCell {
  // MARK: - Properties
  static let identifier = "CalendarCell"

  // MARK: - UI Components
  private let dateLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = UIFont.regularFont(ofSize: 12)
    label.textColor = .white
    return label
  }()

  private let emojiView: UIView = {
    let view = UIView()
    view.frame.size = CGSize(width: 40, height: 40)
    view.layer.cornerRadius = view.frame.width / 2
    return view
  }()

  private lazy var stackView: UIStackView = {
    let stackView = UIStackView(arrangedSubviews: [emojiView, dateLabel])
    stackView.axis = .vertical
    return stackView
  }()

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
    emojiView.backgroundColor = .clear
  }

  // MARK: - Methods
  private func setupViews() {
    self.addSubview(stackView)

    stackView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    emojiView.snp.makeConstraints {
      $0.height.equalTo(40)
    }
  }
  
  func update(day: String) {
    //TODO: 수정필요 - 애초에 View가 그려지지 않도록 하는 방법 찾기
    self.emojiView.backgroundColor = day.isEmpty ? .clear : .whiteGray
    self.dateLabel.text = day
  }
}
