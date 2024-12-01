//
//  MusicMatchViewController.swift
//  Presentation
//
//  Created by 김미래 on 11/25/24.
//
import Domain
import UIKit

final class MusicMatchViewController: BaseViewController<MusicMatchViewModel>, Coordinatable{
  // MARK: - Properties
  // TODO: let 수정
  private var musicDataSources: [MusicTrack]
  weak var coordinator: DefaultMusicMatchCoordinator?

  // MARK: - UI Components
  private let titleLabel = CommonLabel(text: "하임이가 추천하는 음악을 가져왔어요!", font: .bold, size: LayoutConstants.titleThree)

  private let musicTableView: UITableView = {
    let tableView = UITableView(frame: .zero)
    tableView.registerCellClass(cellType: MusicTableViewCell.self)
    tableView.separatorStyle = .none
    tableView.isScrollEnabled = false
    tableView.layer.masksToBounds = true
    tableView.layer.cornerRadius = LayoutConstants.cornerRadius
    tableView.isScrollEnabled = true
    return tableView
  }()

  private let homeButton: CommonRectangleButton = {
    let button = CommonRectangleButton(
      fontStyle: .boldFont(ofSize: LayoutConstants.homeButtonFont),
      backgroundColor: .primary,
      radius: LayoutConstants.cornerRadius
    )
    button.setTitle("메인 화면으로 이동하기",
                    for: .normal)
    return button
  }()

  // MARK: - Initializer
  init(musics: [MusicTrack], isHiddenHomeButton: Bool = false, viewModel: MusicMatchViewModel) {
    // TODO: 삭제
    //self.musicDataSources = musics
    self.musicDataSources = [
      MusicTrack(thumbnail: nil, title: "Atlantis", artist: "샤이니", isrc: "KRA302100123"),
      MusicTrack(thumbnail: nil, title: "Hero", artist: "임영웅", isrc: "KRA382006253"),
      MusicTrack(thumbnail: nil, title: "스물셋", artist: "아이유", isrc: "KRA381500393"),
      MusicTrack(thumbnail: nil, title: "다시 만난 세계", artist: "소녀시대", isrc: "KRA301300044"),
      MusicTrack(thumbnail: nil, title: "Dun Dun Dance", artist: "오마이걸", isrc: "KRB462100515")
    ]

    self.homeButton.isHidden = isHiddenHomeButton
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
  
  deinit {
    coordinator?.didFinish()
  }

  override func viewDidLayoutSubviews() {
    setupTableViewGradient()
  }

  override func setupViews() {
    super.setupViews()

    musicTableView.delegate = self
    musicTableView.dataSource = self

    view.addSubview(titleLabel)
    view.addSubview(musicTableView)
    view.addSubview(homeButton)

    homeButton.addTarget(
      self,
      action: #selector(homeButtondidTap),
      for: .touchUpInside
    )
  }

  override func setupLayoutConstraints() {
    super.setupLayoutConstraints()

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.left.equalTo(LayoutConstants.defaultPadding)
    }

    musicTableView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(LayoutConstants.defaultPadding)
      $0.leading.trailing.equalToSuperview().inset(LayoutConstants.defaultPadding)
      $0.bottom.equalToSuperview().offset(LayoutConstants.tableViewBottom)
    }

    homeButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(LayoutConstants.defaultPadding)
      $0.top.equalTo(musicTableView.snp.bottom).offset(LayoutConstants.homeButtonTop)
      $0.height.equalTo(LayoutConstants.homeButtonHeight)
    }
  }

  @objc func homeButtondidTap() {
    coordinator?.backToMainView()
  }

  override func bindState() {
    super.bindState()

    viewModel.$state
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink { [weak self] state in
        self?.musicTableView.indexPathsForVisibleRows?.forEach({ indexPath in
          guard let cell = self?.musicTableView.cellForRow(at: indexPath) as? MusicTableViewCell,
          let item = self?.musicDataSources[indexPath.row] else { return }
          cell.updatePlayButton(isPlaying: item.isrc == state.isrc)
        })
      }
      .store(in: &cancellable)
  }
}

extension MusicMatchViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int)
  -> Int {
    5
  }
}

extension MusicMatchViewController: UITableViewDataSource, MusicTableViewCellButtonDelegate {
  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath)
  -> UITableViewCell {
    guard indexPath.row < musicDataSources.count else {
      return UITableViewCell()
    }

    let titleText = musicDataSources[indexPath.row].title
    let subTilteText = musicDataSources[indexPath.row].artist
    var imageData: Data?

    let musicTrack = self.musicDataSources[indexPath.row]
    if let imageUrl = musicTrack.thumbnail {
      if let data = try? Data(contentsOf: imageUrl) {
        imageData = data
      }
    }

    guard let cell = tableView.dequeueReusableCell(cellType: MusicTableViewCell.self, indexPath: indexPath) else { return UITableViewCell() }
    cell.delegate = self

    cell.configure(
      imageData: imageData,
      titleText: titleText,
      subTitle: subTilteText,
      track: musicTrack.isrc
    )

    return cell
  }

  func playButtonDidTap(isrc: String?) {
    guard let isrc else { return }
    viewModel.action(.playMusic(isrc))
  }

  func pauseButtonDidTap() {
    viewModel.action(.pauseMusic)
  }
}

private extension MusicMatchViewController {
  enum LayoutConstants {
    static let defaultPadding: CGFloat = 16
    static let titleThree: CGFloat = 20
    static let homeButtonFont: CGFloat = 18
    static let homeButtonTop: CGFloat = 32
    static let cornerRadius: CGFloat = 10
    static let tableViewBottom = UIApplication.screenHeight * 170 / UIApplication.screenHeight * -1
    static let homeButtonHeight = UIApplication.screenHeight * 0.07
  }

  // MARK: - Layout
  func setupTableViewGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = musicTableView.bounds
    gradientLayer.colors = [UIColor.white.cgColor, UIColor.whiteViolet.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0, y: 1)

    let backgroundView = UIView(frame: musicTableView.bounds)
    backgroundView.layer.insertSublayer(
      gradientLayer,
      at: 0
    )

    musicTableView.backgroundView = backgroundView
  }
}
