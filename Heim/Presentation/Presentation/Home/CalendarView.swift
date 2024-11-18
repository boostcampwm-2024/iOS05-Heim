//
//  CalendarView.swift
//  Presentation
//
//  Created by 김미래 on 11/7/24.
//

import UIKit
import SnapKit

final class CalendarView: UIView {
  // MARK: - Calendar Properties
  private let calendar = Calendar.current // 현재의 지역 및 설정에 맞는 Calendar 객체
  private var calendarDate = Date() // 달력에 표시될 날짜
  private var days = [String]() // 달력 날짜 표시 string
  private let dateFormatter = DateFormatter()

  // MARK: - UI Components
  private let yearLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldFont(ofSize: LayoutContants.yearFontSize)
    label.textColor = .white
    return label
  }()

  private let monthStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillProportionally
    stackView.alignment = .center
    return stackView
  }()

  private let previousMonthButton: UIButton = {
    let button = UIButton()
    //TODO: 에셋 파일 추가
    button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    button.tintColor = .white
    //TODO: 버튼 이미지 24 x 24로 꽉차게 적용 
    return button
  }()

  private let nextMonthButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
    button.tintColor = .white
    return button
  }()

  private let monthLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.font = UIFont.boldFont(ofSize: LayoutContants.monthFontSize)
    label.textColor = .white
    return label
  }()

  private let weekStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    return stackView
  }()

  private let separatorLineView: UIView = {
    let view = UIView()
    view.backgroundColor = .whiteGray
    return view
  }()

  private let dayCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.register(
      CalendarCell.self,
      forCellWithReuseIdentifier: CalendarCell.identifier
    )
    collectionView.backgroundColor = .clear
    return collectionView
  }()

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupLayoutConstraints()
    setupMonthStackView()
    setupWeekStackView()
    setupCollectionView()
    configureCalendar()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Methods
  private func setupViews() {
    addSubview(yearLabel)
    addSubview(monthStackView)
    addSubview(previousMonthButton)
    addSubview(nextMonthButton)
    addSubview(monthLabel)
    addSubview(weekStackView)
    addSubview(separatorLineView)
    addSubview(dayCollectionView)
  }

  private func setupLayoutConstraints() {
    yearLabel.snp.makeConstraints {
      $0.top.equalTo(self.safeAreaLayoutGuide)
      $0.left.equalToSuperview().offset(LayoutContants.defaultPadding)
    }

    previousMonthButton.snp.makeConstraints {
      $0.width.equalTo(LayoutContants.buttonSize)
      $0.height.equalTo(LayoutContants.buttonSize)
    }

    nextMonthButton.snp.makeConstraints {
      $0.width.equalTo(LayoutContants.buttonSize)
      $0.height.equalTo(LayoutContants.buttonSize)
    }

    monthStackView.snp.makeConstraints {
      $0.top.equalTo(yearLabel.snp.bottom).offset(LayoutContants.defaultPadding)
      $0.centerX.equalToSuperview()
    }

    weekStackView.snp.makeConstraints {
      $0.top.equalTo(monthStackView.snp.bottom).offset(LayoutContants.weekStackViewTop)
      //TODO: 익스텐션 추후 적용
      $0.width.equalTo(UIScreen.main.bounds.width - LayoutContants.weekStackPadding)
      $0.centerX.equalToSuperview()
    }

    separatorLineView.snp.makeConstraints {
      $0.width.equalTo(weekStackView)
      $0.height.equalTo(LayoutContants.lineHeight)
      $0.top.equalTo(weekStackView.snp.bottom).offset(LayoutContants.lineViewBottom)
      $0.centerX.equalToSuperview()
    }
    
    dayCollectionView.snp.makeConstraints {
      $0.top.equalTo(separatorLineView).offset(LayoutContants.dayCollectionViewTop)
      $0.left.equalToSuperview().offset(LayoutContants.stackViewLeftPadding)
      $0.right.equalToSuperview().offset(LayoutContants.stackViewLeftPadding * -1)
      //TODO: 익스텐션 추후 적용
      $0.height.equalTo(UIScreen.main.bounds.height * 1 / 2 )
    }
  }

  //MARK: - WeekStackViewUI
  private func setupWeekStackView() {
    let dayOfTheWeek = DayofWeek.allCases

    for day in dayOfTheWeek {
      let label = UILabel()
      label.text = day.rawValue
      label.textAlignment = .center
      label.textColor = .white
      label.font = UIFont.boldSystemFont(ofSize: LayoutContants.dayFontSize)

      weekStackView.addArrangedSubview(label)

      if day == .sunday {
        label.textColor = .red
      } else if day == .saturday {
        label.textColor = .blue
      }
    }
  }
  //MARK: - MonthStackViewUI
  private func setupMonthStackView() {
    monthStackView.addArrangedSubview(previousMonthButton)
    monthStackView.addArrangedSubview(monthLabel)
    monthStackView.addArrangedSubview(nextMonthButton)
  }
}

//MARK: UICollectionView
extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  private func setupCollectionView() {
    dayCollectionView.delegate = self
    dayCollectionView.dataSource = self
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = dayCollectionView.dequeueReusableCell(
      withReuseIdentifier: CalendarCell.identifier,
      for: indexPath
    ) as? CalendarCell else { return UICollectionViewCell() }
    cell.update(day: days[indexPath.row])
    return cell
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return days.count
  }

  //TODO: - 수정 필요(너비가 7개로 나누어 떨어지도록 수정)
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let width = dayCollectionView.frame.width / 9
    return CGSize(width: width, height: dayCollectionView.bounds.height / 5)
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    minimumLineSpacingForSectionAt section: Int
  ) -> CGFloat {
    return .zero
  }
}

//MARK: - Calendar Logic
extension CalendarView {
  private func configureCalendar() {
    let components = calendar.dateComponents(
      [
        .year,
        .month
      ],
      from: Date()
    ) //현재 날짜의 년, 월
    calendarDate = calendar.date(from: components) ?? Date() // components를 Date타입으로 변경
    updateCalendar() // 타이틀과 일자 업로드
  }

  //1일이 시작되는 요일 반환
  private func startDayofTheWeek() -> Int {
    return calendar.component(.weekday,from: calendarDate) - 1
  }

  //일자 계산
  private func endDate() -> Int {
    return calendar.range(
      of: .day,
      in: .month,
      for: calendarDate
    )?.count ?? Int()
  }

  // 년, 월 title 변경
  private func updateDateTitle() {
    dateFormatter.dateFormat = "yyyy년 MM월"
    let dateTitle = dateFormatter.string(from: calendarDate)
    let dateComponents = dateTitle.split(separator: " ")
    yearLabel.text = String(dateComponents[0])
    monthLabel.text = String(dateComponents[1])
  }

  // 해당 Month에 따른 일(day)반환
  private func updateDays() {
    days.removeAll()
    let startDayOfTheWeek = startDayofTheWeek()
    let totalDays = startDayOfTheWeek + endDate()

    for day in Int()..<totalDays {
      if day < startDayOfTheWeek {
        days.append("")
        continue
      }
      days.append("\(day - startDayOfTheWeek + 1)")
    }
    dayCollectionView.reloadData()
  }

  // 달력 업데이트
  private func updateCalendar() {
    updateDateTitle()
    updateDays()
  }

  // 저번달로 이동
  private func minusMonth() {
    calendarDate = calendar.date(
      byAdding: DateComponents(month: -1),
      to: calendarDate
    ) ?? Date()
    updateCalendar()
  }

  // 다음달로 이동
  private func plusMonth() {
    calendarDate = calendar.date(
      byAdding: DateComponents(month: 1),
      to: calendarDate
    ) ?? Date()
    updateCalendar()
  }
}

private extension CalendarView {
  enum LayoutContants {
    static let defaultPadding: CGFloat = 16
    static let weekStackPadding: CGFloat = 48
    static let yearFontSize: CGFloat = 28
    static let monthFontSize: CGFloat = 24
    static let dayFontSize: CGFloat = 14
    static let buttonSize: CGFloat = 24
    static let stackViewLeftPadding: CGFloat = 24
    static let lineHeight: CGFloat = 1
    static let lineViewBottom: CGFloat = 4
    static let dayCollectionViewTop: CGFloat = 10
    static let weekStackViewTop: CGFloat = 30
  }
}
