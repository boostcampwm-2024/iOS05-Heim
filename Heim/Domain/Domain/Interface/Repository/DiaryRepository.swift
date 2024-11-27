//
//  DiaryRepository.swift
//  Domain
//
//  Created by 김미래 on 11/20/24.
//

public protocol DiaryRepository {
  func readDiaries(calendarDate: CalendarDate) async throws -> [Diary]
  func saveDiary(data: Diary) async throws
  func deleteDiary(calendarDate: CalendarDate) async throws
}
