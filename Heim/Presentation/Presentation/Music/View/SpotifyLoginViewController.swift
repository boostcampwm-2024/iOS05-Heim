//
//  SpotifyLoginViewController.swift
//  Presentation
//
//  Created by 김미래 on 11/29/24.
//

import UIKit

public class SpotifyLoginViewController: UIViewController {
  private let spotifyView = SpotifyLoginView()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setup()
  }

  private func setup() {
    view.backgroundColor = .white
    view.addSubview(spotifyView)
    spotifyView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}
