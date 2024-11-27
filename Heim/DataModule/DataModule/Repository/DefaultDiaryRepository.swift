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
  
  // MARK: - Initializer
  public init(dataStorage: DataStorage) {
    self.dataStorage = dataStorage
  }
  
  // MARK: - Methods
  public func readDiaries(calendarDate: CalendarDate) async throws -> [Diary] {
    let diaries: [Diary] = try await dataStorage.readData(calendarDate: calendarDate)
    return diaries
  }
  
  public func saveDiary(data: Diary) async throws {
    try await dataStorage.saveData(calendarDate: data.calendarDate, data: data)
  }
  
  public func deleteDiary(calendarDate: CalendarDate) async throws {
    try await dataStorage.deleteData(calendarDate: calendarDate)
  }
}
