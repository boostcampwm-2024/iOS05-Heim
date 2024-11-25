//
//  Seed.swift
//  Domain
//
//  Created by 정지용 on 11/25/24.
//

public struct Seed: Codable {
  public let id: String
  public let type: String
  public let initialPoolSize: Int
  public let afterFilteringSize: Int
  public let afterRelinkingSize: Int
  
  enum CodingKeys: String, CodingKey {
    case id, type
    case initialPoolSize = "initialPoolSize"
    case afterFilteringSize = "afterFilteringSize"
    case afterRelinkingSize = "afterRelinkingSize"
  }
}
