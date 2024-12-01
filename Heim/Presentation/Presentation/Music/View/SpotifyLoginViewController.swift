//
//  SpotifyLoginViewController.swift
//  Presentation
//
//  Created by 김미래 on 11/29/24.
//

import UIKit

final class SpotifyLoginViewController: BaseViewController<SpotifyLoginViewModel> {
  // MARK: - UIComponents
  private let spotifyView = SpotifyLoginView()

  // MARK: - Initializer
  override init(viewModel: SpotifyLoginViewModel) {
    super.init(viewModel: viewModel)
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupLayoutConstraints()
  }

  // MARK: - Methods
  override func setupViews() {
    super.setupViews()
    view.addSubview(spotifyView)
  }

  override func setupLayoutConstraints() {
    super.setupLayoutConstraints()
    spotifyView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
