//
//  CalendarView.swift
//  Presentation
//
//  Created by 김미래 on 11/7/24.
//

import Domain
import UIKit
import SnapKit

protocol CalendarDelegate: AnyObject {
  func previousMonthButtonDidTap(
    _ button: UIButton,
    date: CalendarDate
  )
  
  func nextMonthButtonDidTap(
    _ button: UIButton,
    date: CalendarDate
  )
  
  func collectionViewCellDidTap(
    _ collectionView: UICollectionView, 
    diary: Diary
  )
}

final class CalendarView: UIView {
  // MARK: - Calendar Properties
  weak var delegate: CalendarDelegate?
  private let calendar = Calendar.current // 현재의 지역 및 설정에 맞는 Calendar 객체
  private var currentCalendarDate = Date() // 달력에 표시될 날짜
  private var diaries = [Diary]()
  private var calendarDataSource = [CalendarCellModel]()
  private let dateFormatter = DateFormatter()

  // MARK: - UI Components
  private let yearLabel = CommonLabel(font: .bold, size: LayoutContants.yearFontSize)

  private let monthStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.distribution = .equalSpacing
    stackView.spacing = LayoutContants.defaultPadding
    return stackView
  }()

  private let previousMonthButton: UIButton = {
    let button = UIButton()
    button.setImage(.chevronLeft, for: .normal)
    return button
  }()

  private let nextMonthButton: UIButton = {
    let button = UIButton()
    button.setImage(.chevronRight, for: .normal)
    return button
  }()

  private let monthLabel = CommonLabel(font: .bold, size: LayoutContants.monthFontSize)

  private let weekStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.distribution = .equalSpacing
    return stackView
  }()

  private let separatorLineView: UIView = {
    let view = UIView()
    view.backgroundColor = .whiteGray
    return view
  }()

  private let dayCollectionView: UICollectionView = {
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.registerCellClass(cellType: CalendarCell.self)
    collectionView.backgroundColor = .clear
    return collectionView
  }()

  // MARK: - Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupLayoutConstraints()
    setupWeekStackView()
    configureCalendar()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Methods
  func updateDiaries(_ diaries: [Diary]) {
    self.diaries = diaries
    updateCalendar()
  }
}

// MARK: - Private Extenion
private extension CalendarView {
  func setupViews() {
    dayCollectionView.delegate = self
    dayCollectionView.dataSource = self
    monthStackView.addArrangedSubview(previousMonthButton)
    monthStackView.addArrangedSubview(monthLabel)
    monthStackView.addArrangedSubview(nextMonthButton)
    addSubview(yearLabel)
    addSubview(monthStackView)
    addSubview(weekStackView)
    addSubview(separatorLineView)
    addSubview(dayCollectionView)
    
    previousMonthButton.addTarget(self, action: #selector(minusMonth), for: .touchUpInside)
    nextMonthButton.addTarget(self, action: #selector(plusMonth), for: .touchUpInside)
  }

  func setupLayoutConstraints() {
    yearLabel.snp.makeConstraints {
      $0.top.equalTo(safeAreaLayoutGuide)
      $0.left.equalToSuperview().offset(LayoutContants.defaultPadding)
    }
    
    [previousMonthButton, nextMonthButton].forEach { button in
      button.snp.makeConstraints {
        $0.size.equalTo(LayoutContants.monthButtonSize)
      }
    }
    
    monthStackView.snp.makeConstraints {
      $0.top.equalTo(yearLabel.snp.bottom).offset(LayoutContants.defaultPadding)
      $0.centerX.equalToSuperview()
    }
    
    weekStackView.snp.makeConstraints {
      $0.top.equalTo(monthStackView.snp.bottom).offset(LayoutContants.defaultPadding)
      $0.leading.trailing.equalToSuperview().inset(LayoutContants.weekStackViewHorizontalPadding)
      $0.centerX.equalToSuperview()
    }
    
    separatorLineView.snp.makeConstraints {
      $0.height.equalTo(LayoutContants.separatorLineHeight)
      $0.top.equalTo(weekStackView.snp.bottom).offset(LayoutContants.separatorLineTopPadding)
      $0.leading.trailing.equalTo(weekStackView)
    }
    
    dayCollectionView.snp.makeConstraints {
      $0.top.equalTo(separatorLineView).offset(LayoutContants.collectionViewTopPadding)
      $0.leading.trailing.equalTo(weekStackView)
      $0.bottom.equalToSuperview().offset(-LayoutContants.collectionViewBottomPadding)
    }
  }

  func setupWeekStackView() {
    for day in DayofWeek.allCases {
      let label = CommonLabel(text: day.rawValue, font: .bold, size: LayoutContants.dayFontSize)
      label.textAlignment = .center
      
      switch day {
      case .sunday: label.textColor = .dayRed
      case .saturday: label.textColor = .dayBlue
      default: label.textColor = .white
      }
      
      label.snp.makeConstraints {
        $0.width.equalTo(LayoutContants.cellWidth)
      }
      
      weekStackView.addArrangedSubview(label)
    }
  }
}

// MARK: - Calendar Logic
private extension CalendarView {
  func configureCalendar() {
    let components = calendar.dateComponents([.year, .month], from: Date()) // 현재 날짜의 년, 월
    currentCalendarDate = calendar.date(from: components) ?? Date() // components를 Date타입으로 변경
  }

  // 1일이 시작되는 요일 반환
  func startDayofTheWeek() -> Int {
    return calendar.component(.weekday, from: currentCalendarDate) - 1
  }

  // 일자 계산
  func endDate() -> Int {
    return calendar.range(of: .day, in: .month, for: currentCalendarDate)?.count ?? Int()
  }

  // 년, 월 title 변경
  func updateDateTitle() {
    dateFormatter.dateFormat = "yyyy년 MM월"
    let dateTitle = dateFormatter.string(from: currentCalendarDate)
    let dateComponents = dateTitle.split(separator: " ")
    yearLabel.text = String(dateComponents[0])
    monthLabel.text = String(dateComponents[1])
  }

  // 해당 Month에 따른 일(day)반환
  func updateDays() {
    calendarDataSource.removeAll()
    let startDayOfTheWeek = startDayofTheWeek()
    let totalDays = startDayOfTheWeek + endDate()

    for day in Int()..<totalDays {
      if day < startDayOfTheWeek {
        calendarDataSource.append(CalendarCellModel(day: "", emotion: .none))
        continue
      }
      
      let day = "\(day - startDayOfTheWeek + 1)"
      let emotion = emotionFromDiaries(day: Int(day) ?? 0)
      calendarDataSource.append(CalendarCellModel(day: day, emotion: emotion))
    }
    dayCollectionView.reloadData()
  }
  
  func emotionFromDiaries(day: Int) -> Emotion {
    return diaries
      .filter { $0.calendarDate.year == currentCalendarDate.calendarDate().year }
      .filter { $0.calendarDate.month == currentCalendarDate.calendarDate().month }
      .filter { $0.calendarDate.day == day }
      .first?.emotion ?? .none
  } 

  // 달력 업데이트
  func updateCalendar() {
    updateDateTitle()
    updateDays()
  }

  // 저번달로 이동
  @objc
  func minusMonth() {
    currentCalendarDate = calendar.date(byAdding: DateComponents(month: -1), to: currentCalendarDate) ?? Date()
    delegate?.previousMonthButtonDidTap(previousMonthButton, date: currentCalendarDate.calendarDate())
  }

  // 다음달로 이동
  @objc 
  func plusMonth() {
    currentCalendarDate = calendar.date(byAdding: DateComponents(month: 1), to: currentCalendarDate) ?? Date()
    delegate?.nextMonthButtonDidTap(nextMonthButton, date: currentCalendarDate.calendarDate())
  }
}

// MARK: - CollectionView
extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let cell: CalendarCell = collectionView.dequeueReusableCell(indexPath: indexPath),
          indexPath.row < calendarDataSource.count else { 
      return UICollectionViewCell() 
    }
    
    if (indexPath.row + 1) % 7 == 0 {
      cell.updateDayLabelColor(.dayBlue)
    } else if (indexPath.row + 1) % 7 == 1 {
      cell.updateDayLabelColor(.dayRed)
    }
    
    cell.configure(calendarDataSource[indexPath.row])
    return cell
  }
  
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    return calendarDataSource.count
  }
  
  func collectionView(
    _ collectionView: UICollectionView, 
    didSelectItemAt indexPath: IndexPath
  ) {
    // TODO: 테스트용 임시 데이터 적용
//    delegate?.collectionViewCellDidTap(
//      collectionView, 
//      diary: Diary(
//        emotion: .happiness, 
//        emotionReport: EmotionReport(text: ""), 
//        voice: Voice(audioBuffer: Data()), 
//        summary: Summary(text: "")
//      )
//    )
  }
}

extension CalendarView: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    return CGSize(width: LayoutContants.cellWidth, height: LayoutContants.cellHeight)
  }
}

private extension CalendarView {
  enum LayoutContants {
    static let defaultPadding: CGFloat = 16
    static let weekStackViewHorizontalPadding: CGFloat = 24
    static let yearFontSize: CGFloat = 28
    static let monthFontSize: CGFloat = 24
    static let dayFontSize: CGFloat = 14
    static let monthButtonSize: CGFloat = 24
    static let separatorLineHeight: CGFloat = 1
    static let separatorLineTopPadding: CGFloat = 4
    static let collectionViewTopPadding: CGFloat = 10
    static let cellWidth: Int = Int(UIApplication.screenWidth - Self.weekStackViewHorizontalPadding * 2) / 9
    static let cellHeight: Int = Self.cellWidth + (UIApplication.isMinimumSizeDevice ? Self.cellWidth / 2 : Self.cellWidth)
    static let collectionViewBottomPadding: CGFloat = UIApplication.screenHeight * 0.1
  }
}
