//
//  MusicMatchViewController.swift
//  Presentation
//
//  Created by 김미래 on 11/25/24.
//

import UIKit

// TODO: 수정
struct Music {
  let title: String
  let artist: String
}

final class MusicMatchViewController: UIViewController, Coordinatable {
  // MARK: - Properties
  // TODO: let 수정
  private var musicDataSources: [Music]
  weak var coordinator: DefaultMusicMatchCoordinator?

  // MARK: - UI Components
  private let backgroundImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.image = .background
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private let titleLabel: CommonLabel = {
    let label = CommonLabel(font: .bold, size: LayoutConstants.titleThree)
    label.text = "하임이가 추천하는 음악을 가져왔어요!"
    return label
  }()

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
      radius: 10
    )
    button.setTitle("메인 화면으로 이동하기",
                    for: .normal)
    return button
  }()

  // MARK: - Initializer
  init(musics: [Music]) {
    self.musicDataSources = musics
    // TODO: 삭제
    self.musicDataSources = [Music(title: "슈퍼노바", artist: "#감성힙합#플레이리스트 #해시태그 #해시태..."),
                             Music(title: "슈퍼노바", artist: "#감성힙합#플레이리스트 #해시태그 #해시태..."),
                             Music(title: "슈퍼노바", artist: "#감성힙합#플레이리스트 #해시태그 #해시태..."),
                             Music(title: "슈퍼노바", artist: "#감성힙합#플레이리스트 #해시태그 #해시태..."),
                             Music(title: "슈퍼노바", artist: "#감성힙합#플레이리스트 #해시태그 #해시태...")]
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - LifeCycle
  override func viewDidLoad() {
    setupViews()
    setupLayoutConstraints()
  }

  override func viewDidLayoutSubviews() {
    setupTableViewGradient()
  }

  @objc func homeButtondidTap() {
    coordinator?.pushHomeView()
  }
}

extension MusicMatchViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int)
  -> Int {
    5
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath)
  -> UITableViewCell {
    // TODO: 이미지 url 넘기기
    guard indexPath.row < musicDataSources.count else {
      return UITableViewCell()
    }

    let titleText = musicDataSources[indexPath.row].title
    let subTilteText = musicDataSources[indexPath.row].title

    guard let cell = tableView.dequeueReusableCell(cellType: MusicTableViewCell.self, indexPath: indexPath) else { return UITableViewCell() }

    let action = UIAction { _ in
        // TODO: 뮤직킷 연동
    }

    cell.configure(titleText: titleText,
                   subTitle: subTilteText,
                   action: action)

    return cell
  }

}
private extension MusicMatchViewController {
  enum LayoutConstants {
    static let defaultPadding: CGFloat = 16
    static let titleThree: CGFloat = 20
    static let homeButtonFont: CGFloat = 18
    static let homeButtonTop: CGFloat = 32
    static let cornerRadius: CGFloat = 10
    // TODO: extension 수정
    static let tableViewBottom = UIScreen.main.bounds.height * 170 / UIScreen.main.bounds.height * -1
  }

  // MARK: - Layout
  func setupViews() {
    musicTableView.delegate = self
    musicTableView.dataSource = self

    view.addSubview(backgroundImageView)
    view.addSubview(titleLabel)
    view.addSubview(musicTableView)
    view.addSubview(homeButton)

    homeButton.addTarget(self,
                     action: #selector(homeButtondidTap),
                     for: .touchUpInside)
  }

  func setupLayoutConstraints() {
    backgroundImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

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
    }
  }

  func setupTableViewGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = musicTableView.bounds
    gradientLayer.colors = [UIColor.white.cgColor, UIColor.whiteViolet.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0, y: 1)

    let backgroundView = UIView(frame: musicTableView.bounds)
    backgroundView.layer.insertSublayer(gradientLayer,
                                        at: 0)

    musicTableView.backgroundView = backgroundView
  }
}
