//
//  DiaryRepository.swift
//  Domain
//
//  Created by 김미래 on 11/20/24.
//

public protocol DiaryRepository {
  func readDiary(timeStamp: String) async throws -> Diary
  func saveDiary(timeStamp: String, data: Diary) async throws
  func deleteDiary(timeStamp: String) async throws
  func countTotalDiary() async throws -> Int
}
