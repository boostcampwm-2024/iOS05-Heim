//
//  SettingItem.swift
//  Presentation
//
//  Created by 한상진 on 11/13/24.
//

enum SettingIcon: String {
  case smileIcon 
  case cloudIcon
  case trashIcon
  case infoIcon
  case helpIcon
}

struct SettingItem {
  // MARK: - Properties
  let title: String
  let icon: SettingIcon
  
  // MARK: - Methods
  static func defaultItems() -> [SettingItem] {
    return [
      SettingItem(title: "이름", icon: .smileIcon),
//      SettingItem(title: "iCloud 동기화", icon: .cloudIcon), // TODO: 추후 구현
//      SettingItem(title: "캐시 삭제", icon: .trashIcon), / TODO: 추후 구현
      SettingItem(title: "데이터 초기화", icon: .trashIcon),
      SettingItem(title: "앱 버전", icon: .infoIcon),
      SettingItem(title: "문의하기", icon: .helpIcon),
    ]
  }
}
