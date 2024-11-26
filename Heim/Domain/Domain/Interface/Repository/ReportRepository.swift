//
//  ReportRepository.swift
//  Domain
//
//  Created by 김미래 on 11/20/24.
//

public protocol ReportRepository {
  func fetchEmotions() async throws -> String
}
