//
//  SpotifyLoginView.swift
//  Presentation
//
//  Created by 김미래 on 11/28/24.
//

import UIKit
import SnapKit

protocol SpotifyLoginViewDelegate: AnyObject {
  func didTapLoginButton(loginView: SpotifyLoginView)
}

final class SpotifyLoginView: UIView {
  weak var delegate: SpotifyLoginViewDelegate?
  
  private let logoImageView: UIImageView = {
    let view = UIImageView()
    view.image = .splashRabbit
    return view
  }()

  private let infoLabel = CommonLabel(
    text: """
  Spotify에 로그인해서 음악 추천 기능을 즐겨보세요 !
  로그인 하지 않으면 음악 추천 기능을 사용할 수 없습니다!
""",
    font: .regular,
    size: LayoutConstants.infoLabelFont,
    textColor: .white
  )

  private let loginButton: UIButton = {
    var config = UIButton.Configuration.filled()
    config.baseBackgroundColor = .primary
    config.image = .spotifyLogo
    config.imagePadding = 30
    config.imagePlacement = .leading
    var titleAttribute = AttributedString.init("Login with Spotify")
    titleAttribute.font = .systemFont(ofSize: LayoutConstants.loginButtonFont, weight: .medium)
    config.attributedTitle = titleAttribute
    let button = UIButton(configuration: config)

    return button
  }()

  // MARK: - Initiallizer
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupView()
    setupConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension SpotifyLoginView {
  func setupView() {
    addSubview(logoImageView)
    addSubview(infoLabel)
    addSubview(loginButton)
    infoLabel.textAlignment = .center
    loginButton.addAction(UIAction { [weak self] _ in
      guard let self else { return }
      self.delegate?.didTapLoginButton(loginView: self)
    }, for: .touchUpInside)
  }

  func setupConstraints() {
    logoImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(LayoutConstants.logoImageViewTop)
      $0.height.equalTo(LayoutConstants.logoSize)
      $0.width.equalTo(LayoutConstants.logoSize)
      $0.centerX.equalToSuperview()
    }

    infoLabel.snp.makeConstraints {
      $0.top.equalTo(logoImageView.snp.bottom).offset(LayoutConstants.infoLabelTop)
      $0.centerX.equalToSuperview()
    }

    loginButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(LayoutConstants.loginButtonPadding)
      $0.bottom.equalToSuperview().offset(LayoutConstants.loginButtonButtom)
      $0.height.equalTo(LayoutConstants.loginButtonHeight)
    }
  }
  enum LayoutConstants {
    static let loginButtonPadding: CGFloat = 16
    static let logoSize: CGFloat = UIApplication.screenHeight * 0.28
    static let logoImageViewTop: CGFloat = UIApplication.screenHeight * 0.14
    static let loginButtonButtom: CGFloat = -64
    static let loginButtonHeight = UIApplication.screenHeight * 0.07
    static let infoLabelFont: CGFloat = 16
    static let infoLabelTop: CGFloat = 64
    static let loginButtonFont: CGFloat = 20
  }
}
