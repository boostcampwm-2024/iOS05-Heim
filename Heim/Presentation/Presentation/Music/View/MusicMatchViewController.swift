//
//  MusicMatchViewController.swift
//  Presentation
//
//  Created by 김미래 on 11/25/24.
//

import UIKit

// TODO: 삭제
struct Music {
  let title: String
  let artist: String
}

final class MusicMatchViewController: UIViewController {
  // MARK: - Properties
  private let musics: [Music]
  weak var coordinator: DefaultMusicMatchCoordinator?

  // MARK: - UI Components
  private let backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = .background
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private let titleLabel: CommonLabel = {
    let label = CommonLabel(font: .bold, size: LayoutConstants.titleThree)
    label.text = "하임이가 추천하는 음악을 가져왔어요!" 
    return label
  }()

  // MARK: - Initializer
  init(musics: [Music]) {
    self.musics = musics
    super.init()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - LifeCycle
  override func viewDidLoad() {
    setupViews()
    setupLayoutConstraints()
  }

}

private extension MusicMatchViewController {
  enum LayoutConstants {
    static let defaultPadding: CGFloat = 16
    static let titleThree: CGFloat = 20
  }

  // MARK: - Methods
  func setupViews() {
    view.addSubview(backgroundImageView)
    view.addSubview(titleLabel)
  }

  func setupLayoutConstraints() {
    backgroundImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.left.equalTo(LayoutConstants.defaultPadding)
    }
  }
}
