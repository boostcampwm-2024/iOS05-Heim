//
//  AnalyzeResultUseCase.swift
//  Domain
//
//  Created by 박성근 on 11/27/24.
//

import Foundation

public protocol AnalyzeResultUseCase {
  // MARK: - Properties
  var diaryRepository: DiaryRepository { get }
  
  // MARK: - Methods
  func saveDiary(timeStamp: String, data: Diary) async throws
}

public struct DefaultAnalyzeResultUseCase: AnalyzeResultUseCase {
  // MARK: - Properties
  public let diaryRepository: DiaryRepository
  
  // MARK: - Initializer
  public init(diaryRepository: DiaryRepository) {
    self.diaryRepository = diaryRepository
  }
  
  // MARK: - Methods
  public func saveDiary(timeStamp: String, data: Diary) async throws {
    try await diaryRepository.saveDiary(timeStamp: timeStamp, data: data)
  }
}
