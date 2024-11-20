//
//  DefaultLocalStorage.swift
//  DataStorage
//
//  Created by 박성근 on 11/20/24.
//

import DataModule
import Foundation

// TODO: 한단계 더 추상화를 해야할까?
public final class DefaultLocalStorage: LocalStorage {
  // MARK: - Properties
  private let fileManager: FileManager
  // TODO: baseURL 수정
  private var baseURL: URL

  public init() {
    self.fileManager =  FileManager.default
    self.baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }

  private func diaryDirectoryPath() throws {
    let documentDirectoryPath = try fileManager.url(
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

  public func saveDiary(
    hashValue: String,
    data: Data
  ) throws {
    // TODO: 로직 구현
    let directory = "20241120"
    let fileName = "161610"

    // appending 관련하여 버전별로 처리
    // TODO: Path를 split하여서 디렉토리를 만들어여함
    if #available(iOS 16.0, *) {
      let url = baseURL.appending(path: directory, directoryHint: .isDirectory)
      try createDirectoryIfNeeded(at: url)
    } else {
      let url = baseURL.appendingPathComponent(directory, isDirectory: true)
      try createDirectoryIfNeeded(at: url)
    }
  }

  public func deleteDiary(hashValue: String) throws {
    // TODO: 디렉토리 지우기
  }
}

private extension DefaultLocalStorage {
  // TODO: - url 파싱하는 과정 필요 (년도_월_일로 한정한다)
  func createDirectoryIfNeeded(at url: URL) throws {
    var isDirectory: ObjCBool = false
    if !fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) {
      try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
    }
  }
}
