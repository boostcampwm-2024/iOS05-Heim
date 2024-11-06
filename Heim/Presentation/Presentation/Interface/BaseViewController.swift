//
//  BaseViewController.swift
//  Presentation
//
//  Created by 정지용 on 11/6/24.
//

import Combine
import UIKit

import SnapKit

class BaseViewController<T: ViewModel>: UIViewController {
  // MARK: - Properties
  var cancellable: Set<AnyCancellable> = []
  let viewModel: T
  
  private let backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "background")
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
    
  // MARK: - Initializer
  init(viewModel: T) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    setupLayoutConstraints()
    bindAction()
    bindState()
  }
  
  // MARK: - Methods
  func setupViews() {
    view.addSubview(backgroundImageView)
  }
  
  func setupLayoutConstraints() {
    backgroundImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  func bindAction() {}
  func bindState() {}
}
