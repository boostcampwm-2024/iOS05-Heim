//
//  ReportViewController.swift
//  Presentation
//
//  Created by 김미래 on 11/20/24.
//
import Domain
import UIKit

public final class ReportViewController: BaseViewController<ReportViewModel>, Coordinatable {
  // MARK: - Properties
  weak var coordinator: DefaultReportCoordinator?

  // MARK: - UI Components
  private let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    return scrollView
  }()
  
  private let contentView = UIView()
  private let titleLabel = CommonLabel(text: "하임이와 함께 한 기록", font: .bold, size: LayoutConstants.titleOne)
  
  private let totalReportView: ReportCountView = {
    let reportCountView = ReportCountView()
    reportCountView.layer.cornerRadius = 8
    reportCountView.layer.borderWidth = 1
    reportCountView.layer.borderColor = UIColor.white.cgColor
    return reportCountView
  }()
  
  private let emotionLabel = CommonLabel(textAlignment: .center, font: .regular, size: LayoutConstants.titleThree)
  private let graphView = GraphView()
  
  private let replyTitleLabel = CommonLabel(
    text: "하임이의 답장",
    font: .bold,
    size: LayoutConstants.titleTwo,
    textColor: .white
  )
  
  private let replyTextView = CommonTextAreaView()

  // MARK: - LifeCycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViews()
    setupLayoutConstraints()
  }
  
  public override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    navigationController?.navigationBar.isHidden = true
    viewModel.action(.fetchTotalDiaryCount)
    viewModel.action(.fetchContinuousCount)
    viewModel.action(.fetchMonthCount)
  }

  deinit {
    coordinator?.didFinish()
  }

  // MARK: - LayOut Methods
  override func setupViews() {
    super.setupViews()
    
    view.addSubview(scrollView)
    scrollView.addSubview(contentView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(totalReportView)
    contentView.addSubview(emotionLabel)
    contentView.addSubview(graphView)
    contentView.addSubview(replyTitleLabel)
    contentView.addSubview(replyTextView)
  }

  override func setupLayoutConstraints() {
    super.setupLayoutConstraints()
    
    scrollView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }

    contentView.snp.makeConstraints {
      $0.edges.width.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(LayoutConstants.defaultPadding)
      $0.centerX.equalToSuperview()
    }
    
    totalReportView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(LayoutConstants.defaultPadding)
      $0.centerX.equalToSuperview()
    }

    emotionLabel.snp.makeConstraints {
      $0.top.equalTo(totalReportView.snp.bottom).offset(LayoutConstants.defaultPadding * 3)
      $0.centerX.equalToSuperview()
    }

    graphView.snp.makeConstraints {
      $0.top.equalTo(emotionLabel.snp.bottom).offset(LayoutConstants.graphViewTop)
      $0.height.equalTo(UIApplication.screenHeight * LayoutConstants.graphViewHeight)
      $0.leading.trailing.equalToSuperview().inset(LayoutConstants.graphViewInset)
    }

    replyTitleLabel.snp.makeConstraints {
      $0.top.equalTo(graphView.snp.bottom).offset(LayoutConstants.replyTitleLabelTop)
      $0.centerX.equalToSuperview()
    }

    replyTextView.snp.makeConstraints {
      $0.top.equalTo(replyTitleLabel.snp.bottom).offset(LayoutConstants.defaultPadding)
      $0.leading.trailing.equalToSuperview().inset(LayoutConstants.defaultPadding)
      $0.bottom.lessThanOrEqualToSuperview().offset(-LayoutConstants.bottomPadding)
    }
  }

  override func bindAction() {
    super.bindAction()
    
    viewModel.action(.fetchUserName)
  }
  
  override func bindState() {
    viewModel.$state
      .map { (userName: $0.userName, emotionTitle: $0.mainEmotionTitle) }
      .removeDuplicates { (lhs, rhs) in
        let duplicated = (lhs.userName == rhs.userName) && (lhs.emotionTitle == rhs.emotionTitle)
        return duplicated
      }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (userName, emotionTitle) in
        self?.updateEmotionLabel(userName: userName, emotionTitle: emotionTitle)
      }
      .store(in: &cancellable)
    
    viewModel.$state
      .map { (total: $0.totalCount, continuous: $0.continuousCount, month: $0.monthCount) }
      .removeDuplicates { (lhs, rhs) in
        let duplicated = (lhs.total == rhs.total) && (lhs.continuous == rhs.continuous) && (lhs.month == rhs.month)
        return duplicated
      }
      .receive(on: DispatchQueue.main)
      .sink { [weak self] (total, continuous, month) in
        self?.totalReportView.updateCountLabels(total: total, continuous: continuous, month: month)
      }
      .store(in: &cancellable)
    
    viewModel.$state
      .map { $0.reply }
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.replyTextView.setText($0)
      }
      .store(in: &cancellable)
    
    viewModel.$state
      .map { $0.emotionCountDictionary }
      .removeDuplicates()
      .receive(on: DispatchQueue.main)
      .sink { [weak self] in
        self?.graphView.configureChart($0)
        self?.updateReplyAreaLayout(by: $0)
      }
      .store(in: &cancellable)
  }
}

// MARK: - Private Extenion
private extension ReportViewController {
  func updateEmotionLabel(userName: String, emotionTitle: String) {
    guard !emotionTitle.isEmpty else {
      emotionLabel.text = "아직 \(userName)님께서 작성하신\n 일기가 없습니다!"
      return
    }
    
    let fullText = "그동안 \(userName)님께서 \n가장 많이 느끼신 감정은 \(emotionTitle)이군요"
    let attributedString = NSMutableAttributedString(string: fullText)
    let emotionFont = UIFont.boldFont(ofSize: LayoutConstants.titleThree)
    let range = (fullText as NSString).range(of: emotionTitle)
    attributedString.addAttribute(.font, value: emotionFont, range: range)
    emotionLabel.attributedText = attributedString
  }
  
  func updateReplyAreaLayout(by emotionCountDictionary: [Emotion: Int]) {
    let emotionIsEmpty = emotionCountDictionary.values.reduce(0, +) < 1
    
    replyTitleLabel.snp.remakeConstraints {
      let target = emotionIsEmpty ? emotionLabel.snp.bottom : graphView.snp.bottom
      $0.top.equalTo(target).offset(LayoutConstants.replyTitleLabelTop)
      $0.centerX.equalToSuperview()
    }
  }
  
  enum LayoutConstants {
    static let defaultPadding: CGFloat = 16
    static let titleOne: CGFloat = 28
    static let titleTwo: CGFloat = 24
    static let titleThree: CGFloat = 20
    static let graphViewHeight: CGFloat = 0.257
    static let graphViewInset: CGFloat = 66
    static let graphViewTop: CGFloat = 32
    static let replyTitleLabelTop: CGFloat = 32
    static let bottomPadding: CGFloat = UIApplication.screenHeight * 0.148
  }
}
