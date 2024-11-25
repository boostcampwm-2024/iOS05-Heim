//
//  MusicMatchViewController.swift
//  Presentation
//
//  Created by 김미래 on 11/25/24.
//

import UIKit

// TODO: 삭제
struct Music {
  let title: String
  let artist: String
}

final class MusicMatchViewController: UIViewController {
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
    let tableView = UITableView(frame: .zero,style: .insetGrouped)
//    tableView.backgroundColor = .orange
    tableView.registerCellClass(cellType: MusicTableViewCell.self)
    tableView.separatorStyle = .none
    tableView.isScrollEnabled = false
    tableView.layer.masksToBounds = true
    tableView.layer.cornerRadius = 10
    return tableView
  }()

  // MARK: - Initializer
  init(musics: [Music]) {
    self.musicDataSources = musics
    self.musicDataSources = [Music(title: "슈퍼노바", artist: "에스파"),
                            Music(title: "슈퍼노바", artist: "에스파"),
                            Music(title: "슈퍼노바", artist: "에스파"),
                            Music(title: "슈퍼노바", artist: "에스파"),
                            Music(title: "슈퍼노바", artist: "에스파")]
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
}

extension MusicMatchViewController: UITableViewDelegate {

}

extension MusicMatchViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    5
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // TODO: 앨범 이미지 넘기기
    guard indexPath.row < musicDataSources.count else {
      return UITableViewCell()
    }

    let titleText = musicDataSources[indexPath.row].title
    let subTilte = musicDataSources[indexPath.row].title

    guard let cell = tableView.dequeueReusableCell(cellType: MusicTableViewCell.self, indexPath: indexPath) else { return UITableViewCell() }
    cell.configure(titleText: "슈퍼노바", subTitle: "#감성힙합#플레이리스트 #해시태그 #해시태...")

    return cell

  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return nil
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return CGFloat.leastNormalMagnitude
  }

}
private extension MusicMatchViewController {
  enum LayoutConstants {
    static let defaultPadding: CGFloat = 16
    static let titleThree: CGFloat = 20
  }

  func setupTableViewGradient() {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = musicTableView.bounds
    gradientLayer.colors = [UIColor.white.cgColor, UIColor.secondary.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
    gradientLayer.endPoint = CGPoint(x: 0, y: 1)

    let backgroundView = UIView(frame: musicTableView.bounds)
    backgroundView.layer.insertSublayer(gradientLayer, at: 0)

    musicTableView.backgroundView = backgroundView
  }

  // MARK: - Methods
  func setupViews() {
    view.addSubview(backgroundImageView)
    view.addSubview(titleLabel)
    musicTableView.delegate = self
    musicTableView.dataSource = self
    view.addSubview(musicTableView)
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
      $0.bottom.equalToSuperview().offset(-180) // Bottom에서 196만큼 떨어짐
    }
  }
}
