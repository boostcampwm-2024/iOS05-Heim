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
  private let dataStorage: DataStorageModule
  
  // MARK: - Initializer
  public init(dataStorage: DataStorageModule) {
    self.dataStorage = dataStorage
  }
  
  // MARK: - Methods
  public func readDiary(timeStamp: String) async throws -> Diary {
    let diary: Diary = try await dataStorage.readData(timeStamp: timeStamp)
    return diary
  }
  
  public func saveDiary(
    timeStamp: String,
    data: Diary
  ) async throws {
    try await dataStorage.saveData(timeStamp: timeStamp, data: data)
  }
  
  public func deleteDiary(timeStamp: String) async throws {
    try await dataStorage.deleteData(timeStamp: timeStamp)
  }

  public func countTotalDiary() async throws -> Int {
    return try await dataStorage.countAllFiles()
  }
}
