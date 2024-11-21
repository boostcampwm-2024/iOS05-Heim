//
//  DefaultLocalStorage.swift
//  DataStorage
//
//  Created by 박성근 on 11/20/24.
//

import Domain
import DataModule
import Foundation

public final class DefaultLocalStorage: DataStorageInterface {
  // MARK: - Properties
  private let fileManager: FileManager
  private var baseURL: URL
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  
  public init() {
    self.fileManager = FileManager.default
    self.baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
  
  public func readDiary<T: Decodable>(timeStamp: String) throws -> T {
    let (directory, fileName) = try parseTimeStamp(timeStamp)
    let url: URL
    
    if #available(iOS 16.0, *) {
      url = baseURL.appending(path: directory, directoryHint: .isDirectory)
    } else {
      url = baseURL.appendingPathComponent(directory, isDirectory: true)
    }
    
    let fileURL = url.appendingPathComponent(fileName)
    
    guard fileManager.fileExists(atPath: fileURL.path) else {
      throw StorageError.readError
    }
    
    guard let jsonData = fileManager.contents(atPath: fileURL.path) else {
      throw StorageError.readError
    }
    
    do {
      let data = try decoder.decode(T.self, from: jsonData)
      return data
    } catch {
      throw StorageError.readError
    }
  }
  
  public func saveDiary<T: Encodable>(
    timeStamp: String,
    data: T
  ) throws {
    let (directory, fileName) = try parseTimeStamp(timeStamp)
    let url: URL
    
    // 디렉토리 생성 관련, appending 메서드를 버전별로 처리
    if #available(iOS 16.0, *) {
      url = baseURL.appending(path: directory, directoryHint: .isDirectory)
      try createDirectoryIfNeeded(at: url)
    } else {
      url = baseURL.appendingPathComponent(directory, isDirectory: true)
      try createDirectoryIfNeeded(at: url)
    }
    
    // MARK: - Create File
    do {
      let encodingData = try encoder.encode(data)
      let fileURL = url.appendingPathComponent(fileName)
      fileManager.createFile(atPath: fileURL.path, contents: encodingData)
    } catch {
      throw StorageError.writeError
    }
  }
  
  public func deleteDiary(timeStamp: String) throws {
    let (directory, fileName) = try parseTimeStamp(timeStamp)
    let url: URL
    
    if #available(iOS 16.0, *) {
      url = baseURL.appending(path: directory, directoryHint: .isDirectory)
    } else {
      url = baseURL.appendingPathComponent(directory, isDirectory: true)
    }
    
    let fileURL = url.appendingPathComponent(fileName)
    
    // 파일이 이미 없는 경우 성공
    guard fileManager.fileExists(atPath: fileURL.path) else {
      return
    }
    
    do {
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
    } catch {
      throw StorageError.deleteError
    }
  }
  
  //TODO: - 캐시삭제 구현 예정
}

private extension DefaultLocalStorage {
  func createDirectoryIfNeeded(at url: URL) throws {
    var isDirectory: ObjCBool = false
    
    do {
      if !fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory) {
        try fileManager.createDirectory(at: url, withIntermediateDirectories: true)
      }
    } catch {
      throw StorageError.writeError
    }
  }
  
  func parseTimeStamp(_ timeStamp: String) throws -> (String, String) {
    guard timeStamp.count == 14 else {
      throw StorageError.invalidInput
    }
    
    let directory = String(timeStamp.prefix(8))
    let fileName = String(timeStamp.suffix(6))
    
    return (directory, fileName)
  }
}
