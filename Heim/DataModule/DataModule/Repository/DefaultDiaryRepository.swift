//
//  DefaultDiaryRepository.swift
//  DataModule
//
//  Created by 김미래 on 11/20/24.
//

import Domain
import Foundation

public final class DefaultDiaryRepository: DiaryRepository {
  // MARK: - Properties
  private let dataStorage: DataStorage
  private let jsonEncoder = JSONEncoder()
  private let jsonDecoder = JSONDecoder()
  
  // MARK: - Initializer
  public init(dataStorage: DataStorage) {
    self.dataStorage = dataStorage
  }
  
  // MARK: - Methods
  public func readDiary(timeStamp: String) async throws -> Diary {
    let diary: Diary = try dataStorage.readDiary(timeStamp: timeStamp)
    return diary
  }
  
  public func saveDiary(
    timeStamp: String,
    data: Diary
  ) async throws {
    try dataStorage.saveDiary(timeStamp: timeStamp, data: data)
  }
  
  public func deleteDiary(timeStamp: String) async throws {
    try dataStorage.deleteDiary(timeStamp: timeStamp)
  }
}
