//
//  DiaryRepository.swift
//  Domain
//
//  Created by 김미래 on 11/20/24.
//

public protocol DiaryRepository {
  func readDiary(hashValue: String) async throws -> Diary
  func saveDiary(hashValue: String, data: Diary) async throws
  func deleteDiary(hashValue: String) async throws
}

