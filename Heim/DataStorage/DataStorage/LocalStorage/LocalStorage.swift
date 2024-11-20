//
//  LocalStorage.swift
//  DataStorage
//
//  Created by 박성근 on 11/20/24.
//

import DataModule
import Foundation

// TODO: 한단계 더 추상화를 해야할까?
public final class DefaultLocalStorage: LocalStorageProvider {
  // MARK: - Properties
  private let fileManager = FileManager.default
  // TODO: baseURL 수정
  private let baseURL: URL = URL(fileURLWithPath: "Dummy")
  
  // TODO: init에서의 throws는 어디에서 처리?, 분명히 FileManager url 선언에서의 오류처리는 해야함.
  public init() throws {
    let documentDirectory = try fileManager.url(
      for: .documentDirectory,
      in: .userDomainMask,
      appropriateFor: nil,
      create: true
    )
  }
  
  public func readDiary(hashValue: String) throws -> Data {
    // TODO: 로직 구현
    return Data()
  }
  
  public func saveDiary(hashValue: String, data: Data) throws {
    // TODO: 로직 구현
  }
  
  public func deleteDiary(hashValue: String) throws {
    // TODO: 디렉토리 지우기
  }
}
