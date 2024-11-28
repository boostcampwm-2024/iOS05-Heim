//
//  DefaultLocalStorage.swift
//  DataStorageModule
//
//  Created by 박성근 on 11/20/24.
//

import Domain
import DataModule
import Foundation

public struct DefaultLocalStorage: DataStorage {
  // MARK: - Properties
  private let fileManager: FileManager
  private var baseURL: URL
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  
  public init() {
    self.fileManager = FileManager.default
    self.baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
  
  public func readData<T: Decodable>(calendarDate: CalendarDate) async throws -> T {
    let directory = "Heim/\(calendarDate.year)/\(calendarDate.month)"
    let fileName = calendarDate.toTimeStamp()
    let url: URL
    
    if #available(iOS 16.0, *) {
      url = baseURL.appending(path: directory, directoryHint: .isDirectory)
    } else {
      url = baseURL.appendingPathComponent(directory, isDirectory: true)
    }
    
    guard let subfolderURLs = try? fileManager.contentsOfDirectory(
      at: url, 
      includingPropertiesForKeys: nil, 
      options: .skipsHiddenFiles
    ) else {
      throw StorageError.fileNotExist
    }
    
    // 모든 파일의 데이터를 결합
    guard let combinedJSON = try? makeCombinedJSON(urls: subfolderURLs) else { throw StorageError.readError }
    
    do {
      let data = try decoder.decode(T.self, from: combinedJSON)
      return data
    } catch {
      throw StorageError.readError
    }
  }
  
  public func saveData<T: Encodable>(
    calendarDate: CalendarDate,
    data: T
  ) async throws {
    let directory = "Heim/\(calendarDate.year)/\(calendarDate.month)/\(calendarDate.day)"
    let fileName = calendarDate.toTimeStamp() + ".json"
    let url: URL
    
    if #available(iOS 16.0, *) {
      url = baseURL.appending(path: directory, directoryHint: .isDirectory)
      try createDirectoryIfNeeded(at: url)
    } else {
      url = baseURL.appendingPathComponent(directory, isDirectory: true)
      try createDirectoryIfNeeded(at: url)
    }
    
    // MARK: - Create File
    do {
      encoder.outputFormatting = .prettyPrinted
      let encodingData = try encoder.encode(data)
      let fileURL = url.appendingPathComponent(fileName)
      fileManager.createFile(atPath: fileURL.path, contents: encodingData)
    } catch {
      throw StorageError.writeError
    }
  }
  
  public func deleteData(calendarDate: CalendarDate) async throws {
    let directory = "Heim/\(calendarDate.year)/\(calendarDate.month)/\(calendarDate.day)"
    let fileName = calendarDate.toTimeStamp() + ".json"
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
  
  // MARK: - baseURL을 기준으로 하위의 모든 디렉토리들 삭제
  // TODO: 만약 현재 baseURL(documents)에 path를 추가해서
  // documents/HeimStorage 로 baseURL을 변경한다면 HeimStorage를 한번에 지우는 방법이 더욱 효율적일 거 같습니다.
  public func deleteAll() async throws {
    guard let heimDirectoryURL = URL(string: baseURL.absoluteString + "/Heim") else {
      throw StorageError.deleteError
    }
    
    do {
      let contents = try fileManager.contentsOfDirectory(
        at: heimDirectoryURL,
        includingPropertiesForKeys: nil,
        options: [.skipsHiddenFiles]
      )
      
      for url in contents {
        try fileManager.removeItem(at: url)
      }
    } catch {
      throw StorageError.deleteError
    }
  }
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
  
  // 특정 달에 속한 모든 데이터들을 결합해 반환
  func makeCombinedJSON(urls: [URL]) throws -> Data {
    var combinedData: [Data] = []
    
    for folderURL in urls {
      var isDirectory: ObjCBool = false
      
      // 하위 폴더가 존재하는지 확인
      guard fileManager.fileExists(atPath: folderURL.path, isDirectory: &isDirectory), isDirectory.boolValue,
            let fileURLs = try? fileManager.contentsOfDirectory(
              at: folderURL, 
              includingPropertiesForKeys: nil, 
              options: .skipsHiddenFiles
            ) else {
        throw StorageError.fileNotExist
      }
      
      for fileURL in fileURLs {
        let fileData = try Data(contentsOf: fileURL)
        combinedData.append(fileData)
      }
    }
    
    // 모든 데이터를 하나의 JSON형태로 조합
    var combinedString = "["
    for (index, json) in combinedData.enumerated() {
      // 마지막 항목이 아니라면 쉼표 추가
      if index < combinedData.count - 1 {
        combinedString += (String(data: json, encoding: .utf8) ?? "") + ","
      } else {
        combinedString += (String(data: json, encoding: .utf8)) ?? ""
      }
    }
    combinedString += "]"
    
    guard let jsonData = combinedString.data(using: .utf8) else { return Data() }
    return jsonData
  }
}
