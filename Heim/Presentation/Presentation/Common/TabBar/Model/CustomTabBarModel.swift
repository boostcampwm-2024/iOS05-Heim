//
//  CustomTabBarModel.swift
//  Presentation
//
//  Created by 한상진 on 11/22/24.
//

enum TabBarItems: CaseIterable {
  case home
  case mic
  case report
  
  var iconTitle: String {
    switch self {
    case .home: "calendarIcon"
    case .mic: "micIcon"
    case .report: "reportIcon"
    }
  }
}

struct CustomTabBarModel {
  // MARK: - Properties
  let title: String
  let tab: TabBarItems
  
  // MARK: - Methods
  static func tabBarItems() -> [Self] {
    return [
      Self(title: "캘린더", tab: .home),
      Self(title: "", tab: .mic),
      Self(title: "통계", tab: .report)
    ]
  }
}
