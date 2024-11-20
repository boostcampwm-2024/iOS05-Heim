//
//  LocalStorage.swift
//  DataModule
//
//  Created by 박성근 on 11/20/24.
//

import Foundation

public protocol LocalStorage {
  func readDiary(hashValue: String) throws -> Data
  func saveDiary<T: Codable>(timeStamp: String, data: T) throws
  func deleteDiary(hashValue: String) throws
}
