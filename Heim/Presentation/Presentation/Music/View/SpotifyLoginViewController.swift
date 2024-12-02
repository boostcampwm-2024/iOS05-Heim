//
//  SpotifyLoginViewController.swift
//  Presentation
//
//  Created by 김미래 on 11/29/24.
//

import UIKit

final class SpotifyLoginViewController: BaseViewController<SpotifyLoginViewModel>, Alertable {
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
    viewModel.action(.setup)
  }

  // MARK: - Methods
  override func setupViews() {
    super.setupViews()
    spotifyView.delegate = self
    view.addSubview(spotifyView)
  }

  override func setupLayoutConstraints() {
    super.setupLayoutConstraints()
    spotifyView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  override func bindState() {
    super.bindState()
    
    viewModel.$state
      .receive(on: DispatchQueue.main)
      .map { $0.isLoginFailed ?? false }
      .removeDuplicates()
      .sink { [weak self] flag in
        guard flag else { return }
        self?.presentAlert(type: .loginFailed, leftButtonAction: {})
      }
      .store(in: &cancellable)
    
    viewModel.$state
      .receive(on: DispatchQueue.main)
      .map { $0.isLogined }
      .removeDuplicates()
      .sink { [weak self] flag in
        guard flag else { return }
        self?.dismiss(animated: true)
      }
      .store(in: &cancellable)
  }
}

extension SpotifyLoginViewController: SpotifyLoginViewDelegate {
  func didTapLoginButton(loginView: SpotifyLoginView) {
    viewModel.action(.authorize)
    print("hi?")
  }
}
