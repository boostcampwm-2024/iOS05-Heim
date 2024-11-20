//
//  Summary.swift
//  Domain
//
//  Created by 정지용 on 11/19/24.
//

public struct Summary: Codable {
  public let text: String
  public init(text: String) {
    self.text = text
  }
}
