//
//  DefaultLocalStorage.swift
//  DataStorage
//
//  Created by 박성근 on 11/20/24.
//

import Domain
import DataModule
import Foundation

// TODO: 한단계 더 추상화를 해야할까?
public final class DefaultLocalStorage: DataStorage {

  // MARK: - Properties
  private let fileManager: FileManager
  private var baseURL: URL
  private let encoder = JSONEncoder()
  public init() {
    self.fileManager =  FileManager.default
    self.baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }

  public func readDiary<T: Decodable>(timeStamp: String) throws -> T {
    // TODO: timeStamp를 split하는 로직 구현
    let directory = "20241120"
    let fileName = "161610"
    let url: URL

    // 파일이 진짜루에요 가짜루에요
    if #available(iOS 16.0, *) {
      url = baseURL.appending(path: directory, directoryHint: .isDirectory)
    } else {
      url = baseURL.appendingPathComponent(directory, isDirectory: true)
    }

    let fileURL = url.appendingPathComponent(fileName)

    guard fileManager.fileExists(atPath: fileURL.path) else {
      throw IOError.readError
    }

    guard let jsonData = fileManager.contents(atPath: fileURL.path) else {
      throw IOError.readError
    }

    let data = try decoder.decode(T.self, from: jsonData)

    return data
  }

  public func saveDiary<T>(
    timeStamp: String,
    data: T
  ) throws where T: Codable {
    // TODO: timeStamp를 split하는 로직 구현
    let directory = "20241120"
    let fileName = "161610"
    let url: URL
    
    // 디렉토리 생성 관련, appending 메서드를 버전별로 처리
    if #available(iOS 16.0, *) {
      url = baseURL.appending(path: directory, directoryHint: .isDirectory)
      try createDirectoryIfNeeded(at: url)
    } else {
      url = baseURL.appendingPathComponent(directory, isDirectory: true)
      try createDirectoryIfNeeded(at: url)
    }
    
    // MARK: - Data to JSON
    let json = try JSONEncoder().encode(data)
    
    // MARK: - Save File
    let fileURL = url.appendingPathComponent(fileName)
    fileManager.createFile(atPath: fileURL.path, contents: json)
  }
  
  public func deleteDiary(hashValue: String) throws {
    // TODO: 디렉토리 지우기
    // hashValue를 split해서 경로 찾기
    // 파일 진짜루에요 가짜루에요
    // 있으면 지우기
    // 없으면 리턴
    let fileURL = url.appendingPathComponent(fileName)

    // 파일이 이미 없는 경우 성공
    guard fileManager.fileExists(atPath: fileURL.path) else {
      return
    }

    // 파일 삭제
    try fileManager.removeItem(at: fileURL)

    // 디렉토리가 비어있다면 디렉토리도 삭제
    let directoryContents = try fileManager.contentsOfDirectory(
      at: url,
      includingPropertiesForKeys: nil
    )

    if directoryContents.isEmpty {
      try fileManager.removeItem(at: url)
    }
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
