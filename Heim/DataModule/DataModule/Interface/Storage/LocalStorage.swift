//
//  LocalStorage.swift
//  DataModule
//
//  Created by 박성근 on 11/20/24.
//

import Foundation

public protocol LocalStorage {
  func readDiary(hashValue: String) throws -> Data
  func saveDiary(hashValue: String, data: Data) throws
  func deleteDiary(hashValue: String) throws
}
