//
//  DiaryUseCase.swift
//  Domain
//
//  Created by 김미래 on 11/20/24.
//

import Foundation

public protocol DiaryUseCase {
  // MARK: - Properties
  var diaryRepository: DiaryRepository { get }

  // MARK: - Methods
  func readDiary(hashValue: String) async throws -> Diary
  func saveDiary(hashValue: String, data: Diary) async throws
  // TODO: 인덱스 접근 고려
  func deleteDiary(hashValue: String) async throws
}

public struct DefaultDiaryUseCase: DiaryUseCase {
  // MARK: - Properties
  public let diaryRepository: DiaryRepository

  // MARK: - Initializer
  public init(diaryRepository: DiaryRepository) {
    self.diaryRepository = diaryRepository
  }

  // MARK: - Methods
  public func readDiary(hashValue: String) async throws -> Diary {
    // TODO: repository에서 받아오는 걸로 수정 필요
    return try await diaryRepository.readDiary(hashValue: hashValue)
  }
  
  public func saveDiary(hashValue: String, data: Diary) async throws {
    // TODO: 수정 필요
  }
  
  public func deleteDiary(hashValue: String) async throws {
    // TODO: 수정 필요
  }
  

}
