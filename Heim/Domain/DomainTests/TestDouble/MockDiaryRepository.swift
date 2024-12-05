//
//  MockDiaryRepository.swift
//  DomainTests
//
//  Created by 정지용 on 12/5/24.
//

@testable import Domain

final class MockDiaryRepository: DiaryRepository {
  struct CallCount {
    var readDiaries = 0
    var readTotalDiaries = 0
    var saveDiary = 0
    var deleteDiary = 0
  }
  
  struct Return {
    var readDiaries: [Diary]!
    var readTotalDiaries: [Diary]!
  }
  
  var callCount = CallCount()
  var returnValue = Return()
  
  func readDiaries(calendarDate: CalendarDate) async throws -> [Diary] {
    callCount.readDiaries += 1
    return returnValue.readDiaries
  }
  
  func readTotalDiaries() async throws -> [Diary] {
    callCount.readTotalDiaries += 1
    return returnValue.readTotalDiaries
  }
  
  func saveDiary(data: Diary) async throws {
    callCount.saveDiary += 1
  }
  
  func deleteDiary(calendarDate: CalendarDate) async throws {
    callCount.deleteDiary += 1
  }
}
