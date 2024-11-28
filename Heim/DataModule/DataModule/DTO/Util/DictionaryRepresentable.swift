//
//  DictionaryRepresentable.swift
//  Domain
//
//  Created by 정지용 on 11/25/24.
//

import Foundation

/// 해당 프로젝트에서 query는 Dictonary로 설계되었지만,
/// 너무 많은 parameter를 사용하는 경우 DTO로 구현하기 위해 설계되었습니다.
///
/// 현재 snake_case를 사용하는 경우에만 구현이 되어 있습니다.
/// 필요 시 camelCase 또는 PascalCase에도 구현할 수 있습니다.
protocol DictionaryRepresentable {
  var dictionary: [String: Any] { get }
}

extension DictionaryRepresentable {
  func toSnakeCaseDictionary() -> [String: Any] {
    var dict = [String: Any]()
    let mirror = Mirror(reflecting: self)
    
    for child in mirror.children {
      if let key = child.label {
        if let optionalValue = child.value as? OptionalProtocol {
          if optionalValue.isNil {
            continue
          }
        }
        if let unwrapValue = unwrap(child.value) {
          dict[key.toSnakeCase()] = String(describing: unwrapValue)
        }
      }
    }
    return dict
  }
  
  private func unwrap(_ value: Any) -> Any? {
    let mirror = Mirror(reflecting: value)
    if mirror.displayStyle == .optional {
      return mirror.children.first?.value
    }
    return value
  }
}

// MARK: - String extension
private extension String {
  func toSnakeCase() -> String {
    guard !isEmpty else { return self }
    var result = ""
    for char in self {
      if char.isUppercase {
        result.append("_")
        result.append(char.lowercased())
      } else {
        result.append(char)
      }
    }
    return result.trimmingCharacters(in: CharacterSet(charactersIn: "_"))
  }
}

private protocol OptionalProtocol {
  var isNil: Bool { get }
}

extension Optional: OptionalProtocol {
  var isNil: Bool {
    return self == nil
  }
}
