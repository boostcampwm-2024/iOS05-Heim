//
//  SpotifyLoginView.swift
//  Presentation
//
//  Created by 김미래 on 11/28/24.
//

import UIKit
import SnapKit

final class SpotifyLoginView: UIView {
  private let logoImageView: UIImageView = {
    let view = UIImageView()
    view.image = .spotifyFullLogo
    return view
  }()

  private let loginButton: UIButton = {
    var config = UIButton.Configuration.filled()
    config.baseForegroundColor = .black
    config.baseBackgroundColor = .white
    config.image = .spotifyLogo
    config.imagePadding = 10
    config.imagePlacement = .leading
    config.background.strokeColor = .black
    var titleAttribute = AttributedString.init("Login with Spotify")
    titleAttribute.font = .systemFont(ofSize: 20.0, weight: .medium)
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
    addSubview(loginButton)
  }

  func setupConstraints() {
    logoImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(LayoutConstants.logoImageViewTop)
      $0.height.equalTo(LayoutConstants.logoImageViewHeight)
      $0.leading.trailing.equalToSuperview().inset(LayoutConstants.logoImageViewPadding)
    }

    loginButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(LayoutConstants.loginButtonPadding)
      $0.leading.trailing.equalToSuperview().inset(LayoutConstants.loginButtonPadding)
      $0.top.equalTo(logoImageView.snp.bottom).offset(LayoutConstants.loginButtonTop)
      $0.height.equalTo(LayoutConstants.loginButtonHeight)
    }

    enum LayoutConstants {
      static let loginButtonPadding: CGFloat = 48
      static let logoImageViewTop: CGFloat = UIApplication.screenHeight * 0.276
      static let logoImageViewHeight: CGFloat = UIApplication.screenHeight * 0.1
      static let logoImageViewPadding = 32
      static let loginButtonTop: CGFloat = UIApplication.screenHeight * 0.25
      static let loginButtonHeight = UIApplication.screenHeight * 0.07
    }
  }
}
