//
//  DefaultReportRepository.swift
//  DataModule
//
//  Created by 김미래 on 11/20/24.
//

import Domain

public final class DefaultReportRepository: ReportRepository {
  // MARK: - 추후구현
  public init() {}

  public func fetchEmotions() async throws -> String {
    return "기쁨"
  }
  

}
