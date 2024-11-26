//
//  DataStorageModule.swift
//  DataModule
//
//  Created by 박성근 on 11/20/24.
//

import Foundation

public protocol DataStorageModule {
  func readData<T: Decodable>(timeStamp: String) async throws -> T
  func saveData<T: Encodable>(timeStamp: String, data: T) async throws
  func deleteData(timeStamp: String) async throws
  // 모든 기록 삭제
  func deleteAll() async throws
}
