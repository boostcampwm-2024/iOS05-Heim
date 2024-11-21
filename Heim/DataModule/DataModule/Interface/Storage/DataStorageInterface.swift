//
//  DataStorageInterface.swift
//  DataModule
//
//  Created by 박성근 on 11/20/24.
//

import Foundation

// MARK: 모듈과의 이름이 겹처 interface를 붙여주었습니다.
public protocol DataStorageInterface {
  func readDiary<T: Decodable>(timeStamp: String) throws -> T
  func saveDiary<T: Encodable>(timeStamp: String, data: T) throws
  func deleteDiary(timeStamp: String) throws
}
