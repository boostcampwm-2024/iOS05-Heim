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
  case recordToggle
  case refresh
  case next
  case close
}

protocol DiaryDetailViewDelegate: AnyObject {
  func buttonDidTap(
    _ recordingView: RecordView,
    _ item: DiaryDetailViewButtonItem
  )
}

final class RecordView: UIView {
  // MARK: - Properties
  weak var delegate: DiaryDetailViewDelegate?

  private var navigationButtons: [UIButton] = []

  // MARK: - UI Components

  // MARK: - Initialize
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupLayoutConstraints()
    setupActions()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Setup
  private func setupViews() {
    
  }

  private func setupLayoutConstraints() {
    
  }

  private func setupActions() {
    
  }
}
