//
//  ReportUseCase.swift
//  Domain
//
//  Created by 김미래 on 11/20/24.
//

public protocol ReportUseCase {
  // MARK: - Properties
  var reportUseCase: ReportRepository { get }

  // MARK: - Methods
  func fetchEmotions() async throws -> String
}

public struct DefaultReportUseCase: ReportUseCase {
  
  public var reportUseCase: ReportRepository

  // MARK: - Initializer
  public init(reportUseCase: ReportRepository) {
    self.reportUseCase = reportUseCase
  }

  // MARK: Method
  public func fetchEmotions() async throws -> String {
    let emotion = try await reportUseCase.fetchEmotions()
    return emotion
  }
}
