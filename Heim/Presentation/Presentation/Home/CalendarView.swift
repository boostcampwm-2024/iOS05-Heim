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
  private var yearLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.boldFont(ofSize: CGFloat(28))
    label.textColor = .white
    return label
  }()

  private let previousMonthButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
    button.tintColor = .white
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
    label.font = UIFont.boldFont(ofSize: CGFloat(24))
    label.textColor = .white
    return label
  }()

  private let weekStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.spacing = 38
    return stackView
  }()

  //TODO: 길이를 고정값으로 할지 결정 필요
  private let separatorLineView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(red: 233 / 255.0, green: 235 / 255.0, blue: 137 / 255.0 , alpha: 0.3)
    return view
  }()

  private var dayCollectionView: UICollectionView = {
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
    setupWeekStackView()
    setupCollectionView()
    configureCalendar()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Methods
  func setupViews() {
    self.addSubview(yearLabel)
    self.addSubview(previousMonthButton)
    self.addSubview(nextMonthButton)
    self.addSubview(monthLabel)
    self.addSubview(weekStackView)
    self.addSubview(separatorLineView)
    self.addSubview(dayCollectionView)
  }

  func setupLayoutConstraints() {

    yearLabel.snp.makeConstraints {
      $0.top.equalTo(self).offset(92)
      $0.left.equalTo(self).offset(16)
    }

    previousMonthButton.snp.makeConstraints {
      $0.left.equalTo(self).offset(134)
      $0.top.equalTo(self).offset(132)
      $0.width.equalTo(17)
      $0.height.equalTo(19)
    }

    monthLabel.snp.makeConstraints {
      $0.left.equalTo(previousMonthButton.snp.right).offset(14)
      $0.right.equalTo(nextMonthButton.snp.left).offset(-14)
      $0.centerY.equalTo(previousMonthButton)
    }

    nextMonthButton.snp.makeConstraints {
      $0.left.equalTo(self).offset(239)
      $0.top.equalTo(self).offset(132)
      $0.width.equalTo(17)
      $0.height.equalTo(19)
    }

    weekStackView.snp.makeConstraints {
      $0.top.equalTo(self).offset(199)
      $0.width.equalTo(dayCollectionView).inset(12)
      $0.height.equalTo(18)
      $0.centerX.equalTo(self)
    }

    separatorLineView.snp.makeConstraints {
      $0.width.equalTo(317)
      $0.height.equalTo(1)
      $0.top.equalTo(weekStackView.snp.bottom).offset(3.75)
      $0.centerX.equalTo(self)
    }

    dayCollectionView.snp.makeConstraints {
      $0.top.equalTo(self).offset(228)
      $0.left.equalTo(self).offset(24)
      $0.right.equalTo(self).offset(-24)
      $0.height.equalTo(490)
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
      label.font = UIFont.boldSystemFont(ofSize: 14)

      self.weekStackView.addArrangedSubview(label)

      if day == .sunday {
        label.textColor = .red
      } else if day == .saturday {
        label.textColor = .blue
      }
    }
  }
}

//MARK: UICollectionView
extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  private func setupCollectionView() {
    self.dayCollectionView.delegate = self
    self.dayCollectionView.dataSource = self
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell = dayCollectionView.dequeueReusableCell(
      withReuseIdentifier: CalendarCell.identifier,
      for: indexPath
    ) as? CalendarCell else { return UICollectionViewCell() }
    cell.update(day: self.days[indexPath.row])
    return cell
  }

  public func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return self.days.count
  }

  //TODO: - 수정 필요(너비가 7개로 나누어 떨어지도록 수정)
  public func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let width = self.dayCollectionView.frame.width / 9
    return CGSize(width: width, height: 80)
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
    let components = self.calendar.dateComponents(
      [
        .year,
        .month
      ],
      from: Date()
    ) //현재 날짜의 년, 월
    self.calendarDate = self.calendar.date(from: components) ?? Date() // components를 Date타입으로 변경
    self.updateCalendar() // 타이틀과 일자 업로드
  }

  //1일이 시작되는 요일 반환
  private func startDayofTheWeek() -> Int {
    return self.calendar.component(.weekday,from: self.calendarDate) - 1
  }

  //일자 계산
  private func endDate() -> Int {
    return self.calendar.range(
      of: .day,
      in: .month,
      for: self.calendarDate
    )?.count ?? Int()
  }

  // 년, 월 title 변경
  private func updateDateTitle() {
    self.dateFormatter.dateFormat = "yyyy년 MM월"
    let dateTitle = self.dateFormatter.string(from: self.calendarDate)
    let dateComponents = dateTitle.split(separator: " ")
    self.yearLabel.text = String(dateComponents[0])
    self.monthLabel.text = String(dateComponents[1])
  }

  // 해당 Month에 따른 일(day)반환
  private func updateDays() {
    self.days.removeAll()
    let startDayOfTheWeek = self.startDayofTheWeek()
    let totalDays = startDayOfTheWeek + self.endDate()

    for day in Int()..<totalDays {
      if day < startDayOfTheWeek {
        self.days.append("")
        continue
      }
      self.days.append("\(day - startDayOfTheWeek + 1)")
    }
    self.dayCollectionView.reloadData()
  }

  // 달력 업데이트
  private func updateCalendar() {
    self.updateDateTitle()
    self.updateDays()
  }

  // 저번달로 이동
  private func minusMonth() {
    self.calendarDate = self.calendar.date(
      byAdding: DateComponents(month: -1),
      to: self.calendarDate
    ) ?? Date()
    self.updateCalendar()
  }

  // 다음달로 이동
  private func plusMonth() {
    self.calendarDate = self.calendar.date(
      byAdding: DateComponents(month: 1),
      to: self.calendarDate
    ) ?? Date()
    self.updateCalendar()
  }
}


