//
//  DiaryDetailViewController.swift
//  Presentation
//
//  Created by 박성근 on 11/19/24.
//

import Domain
import UIKit

final class DiaryDetailViewController: BaseViewController<DiaryDetailViewModel>, Coordinatable {
  // MARK: - UIComponents
  private let contentView = DiaryDetailView()
  
  // MARK: - Properties
  weak var coordinator: DefaultDiaryDetailCoordinator?
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
    setupLayoutConstraints()
    setupNavigationBar()
    viewModel.action(.fetchDiary)
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
  
  private func setupNavigationBar() {
    let deleteButton = UIBarButtonItem(
      image: UIImage(systemName: "xmark.fill"),
      style: .plain,
      target: self,
      action: #selector(deleteButtonTapped)
    )
    deleteButton.tintColor = UIColor.white
    navigationItem.rightBarButtonItem = deleteButton
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    coordinator?.didFinish()
  }
  
  override func bindState() {
    super.bindState()
    
    // TODO: state를 통해 configure를 사용할 예정
    viewModel.$state
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] state in
        self?.contentView.configure(
          date: "2024년 10월 31일",
          description: "성근님, 화가 나는 하루를 보내셨군요.",
          content: """
            이 지면에 실리는 글은 띄어쓰기 포함 700자 안팎이다. 초고를 쓰고 문서 통계창을 열어 글자수를 확인한 다음 분량을 조정한다. 
            ‘길 위의 이야기’ 코너를 맡고 처음 두어 달 정도 나는 꽤 애를 먹었다. 떠오르는 대로 키보드를 누르다 보면 1,000자를 훌쩍 넘기기가 다반사였고, 
            작정하고 짧게 맺으려 하면 꼭 두세 문장이 모자랐다. 쓰는 것 자체보다 줄이거나 늘이는 게 더 어려워 답답한 날이 많았다. 
            그런데 참 이상한 일이다. 언젠가부터 700자가 몸에 맞는 옷처럼 조금씩 편해졌으니 말이다. 글감을 찾고 보면 700자 분량의 재료였다. 
            문장의 호흡도 700자에 맞게 바뀌어갔다. 맥락은 좀 다르지만, 미디어는 메시지라고 했던 마샬 맥루한의 말을 떠올려본다. 
            넓게 해석하자면 형식 혹은 그릇이 내용을 결정한다는 뜻일 테다. 정해진 틀에 맞춰 2년 가까이 일상과 생각을 적고 보니 
            이제 비로소 나는 ‘형식의 힘’을 실감하게 된다. 700자가 아니었다면 그런 이야기를 쓸 수 없었을 것이다. 
            700자가 아니었다면 다른 이야기가 씌어졌을 것이다. 형식이 그야말로 내용을 창조한 셈이다. 삶도 그러하지 않을까. 
            주어진 형식에 우리는 그저 얽매이는 것이 아니라, 얽매임을 통해 자기만의 고유한 빛과 결을 만들어가게 되는 것일지도 모른다. 
            700자에 맞춰 오늘 마지막 글을 쓴다. 그간 읽어주신 분들께 감사의 마음 전한다. 다음 주부터 ‘길 위의 이야기’에 오를 
            다른 빛깔 다른 결의 700자들이 벌써부터 기대된다.시인
            """
        )
      }
      .store(in: &cancellable)
  }
  
  @objc private func deleteButtonTapped() {
    // TODO: 삭제 로직
  }
}

extension DiaryDetailViewController: DiaryDetailViewDelegate {
  func buttonDidTap(
    _ recordingView: DiaryDetailView,
    _ item: DiaryDetailViewButtonItem
  ) {
    switch item {
    case .musicRecomendation:
      coordinator?.pushMusicRecommendationView()
    case .heimReply:
      coordinator?.pushHeimReplyView()
    case .replayVoice:
      coordinator?.pushDiaryReplayView()
    }
  }
}
