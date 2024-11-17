//
//  RecordViewController.swift
//  Presentation
//
//  Created by 박성근 on 11/17/24.
//

import Domain
import UIKit

final class RecordViewController: BaseViewController<RecordViewModel>, Coordinatable {
  // MARK: - UIComponents
  private let contentView = RecordView()
  
  // MARK: - Properties
  weak var coordinator: DefaultRecordCoordinator?
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    coordinator?.didFinish()
  }
  
  override func setupViews() {
    super.setupViews()
    contentView.delegate = self
    view.addSubview(contentView)
  }
  
  override func setupLayoutConstraints() {
    super.setupLayoutConstraints()
    
    contentView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }
  
  override func bindState() {
    //    viewModel.$state
    //      .receive(on: DispatchQueue.main)
    //      .sink { [weak self] state in
    //
    //      }
    //      .store(in: %cancellable)
  }
}

extension RecordViewController: RecordViewDelegate {
  func screenHeight() -> CGFloat {
    return screen()?.bounds.height ?? UIScreen.main.bounds.height
  }
  
  func buttonDidTap(_ recordingView: RecordView, _ item: RecordViewButtonItem) {
    // TODO: 버튼의 종류에 따른 기능 구현
  }
}
