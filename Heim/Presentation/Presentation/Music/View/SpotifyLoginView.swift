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
    var titleAttribute = AttributedString.init("Login with Spotify")
    titleAttribute.font = .systemFont(ofSize: 26.0, weight: .medium)
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
      $0.top.equalToSuperview().offset(UIApplication.screenHeight * 0.276)
      $0.height.equalTo(UIApplication.screenHeight * 0.1)
      $0.leading.trailing.equalToSuperview().inset(20)

    }

    loginButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(LayoutConstants.defaultPadding * 2)
      $0.top.equalTo(logoImageView.snp.bottom).offset(LayoutConstants.loginButtonTopTop)
      $0.height.equalTo(LayoutConstants.loginButtonTop)
    }

    enum LayoutConstants {
      static let defaultPadding: CGFloat = 16
    
      static let loginButtonTopTop: CGFloat = 158
      static let loginButtonTop = UIApplication.screenHeight * 0.07
    }

  }
}
