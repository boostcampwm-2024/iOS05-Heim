//
//  HomeView.swift
//  Presentation
//
//  Created by 김미래 on 11/6/24.
//

import UIKit
import SnapKit

public class HomeViewController: UIViewController {

  // MARK: - UI Components
  private var contentView = CalendarView()

  private let backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "Background")
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  public override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupLayoutConstraints()
  }

  // MARK: - Methods
  func setupViews() {
    view.addSubview(backgroundImageView)
    view.addSubview(contentView)
  }

  func setupLayoutConstraints() {
    backgroundImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
}

