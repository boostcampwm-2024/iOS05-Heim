//
//  DataStorage.swift
//  DataModule
//
//  Created by 박성근 on 11/20/24.
//

import Foundation

public protocol DataStorage {
  func readDiary<T: Codable>(timeStamp: String) throws -> T
  func saveDiary<T: Codable>(timeStamp: String, data: T) throws
  func deleteDiary(timeStamp: String) throws
}
