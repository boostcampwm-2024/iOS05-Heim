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
  private let baseURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  private let rootPath = "Heim"
  private let diaryPath = "/Diary"
  
  // MARK: - Initializer
  public init() {
    self.fileManager = FileManager.default
  }
  
  // MARK: - Methods
  public func readData<T: Decodable>(
    directory: String, 
    fileName: String
  ) async throws -> T {
    let url = fullPathURL(directory: rootPath + directory + "/\(fileName)")
    
    guard fileManager.fileExists(atPath: url.path), let data = try? Data(contentsOf: url) else {
      throw StorageError.fileNotExist
    }
    
    return try decodedData(data: data)
  }
  
  public func readData<T: Decodable>(calendarDate: CalendarDate) async throws -> T {
    let directory = rootPath + diaryPath + "/\(calendarDate.year)/\(calendarDate.month)"
    let url = fullPathURL(directory: directory)
    guard let subfolderURLs = try? fileManager.contentsOfDirectory(
      at: url, 
      includingPropertiesForKeys: nil, 
      options: .skipsHiddenFiles
    ) else {
      throw StorageError.fileNotExist
    }
    
    // 모든 파일의 데이터를 결합
    guard let combinedJSON = try? makeCombinedJSON(urls: subfolderURLs) else { throw StorageError.readError }
    return try decodedData(data: combinedJSON)
  }
  
  public func saveData<T: Encodable>(
    directory: String, 
    fileName: String, 
    data: T
  ) async throws {
    let url = fullPathURL(directory: rootPath + "/\(directory)")
    try createDirectoryIfNeeded(at: url)
    try save(url: url, fileName: fileName, data: data)
  }
  
  public func saveData<T: Encodable>(
    calendarDate: CalendarDate,
    data: T
  ) async throws {
    let directory = rootPath + diaryPath + "/\(calendarDate.year)/\(calendarDate.month)/\(calendarDate.day)"
    let fileName = calendarDate.toTimeStamp() + ".json"
    let url = fullPathURL(directory: directory)
    try createDirectoryIfNeeded(at: url)
    try save(url: url, fileName: fileName, data: data)
  }
  
  public func deleteData(calendarDate: CalendarDate) async throws {
    let directory = rootPath + diaryPath + "/\(calendarDate.year)/\(calendarDate.month)/\(calendarDate.day)"
    let fileName = calendarDate.toTimeStamp() + ".json"
    let url = fullPathURL(directory: directory)
    let fileURL = url.appendingPathComponent(fileName)
    
    guard fileManager.fileExists(atPath: fileURL.path) else { return }
    
    do {
      try fileManager.removeItem(at: fileURL)
    
      // 디렉토리가 비어있다면 디렉토리도 삭제
      let directoryContents = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
    
      if directoryContents.isEmpty {
        try fileManager.removeItem(at: url)
      }
    } catch {
      throw StorageError.deleteError
    }
  }
  
  public func deleteAll() async throws {
    let fullPathURL = fullPathURL(directory: "\(rootPath)" + diaryPath)
    do {
      let contents = try fileManager.contentsOfDirectory(
        at: fullPathURL,
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
  
  public func readAll<T: Decodable>(directory: String) async throws -> T {
    let rootDirectoryPath = fullPathURL(directory: rootPath + directory)
    var fileURLs: [URL] = []
    
    func countFilesInDirectory(_ directory: URL) throws {
      do {
        let contents = try fileManager.contentsOfDirectory(
          at: directory, 
          includingPropertiesForKeys: nil, 
          options: .skipsHiddenFiles
        )
        
        for item in contents {
          var isDirectory: ObjCBool = false
          guard fileManager.fileExists(atPath: item.path, isDirectory: &isDirectory) else { continue } 
          
          if isDirectory.boolValue {
            try countFilesInDirectory(item)
          } else if item.path.hasSuffix(".json") {
            fileURLs.append(item)
          }
        }
      } catch {
        throw StorageError.readError
      }
    }
    
    try countFilesInDirectory(rootDirectoryPath)
    let datas = try fileURLs.map { try Data(contentsOf: $0) }
    let jsonDatas = assembleJSON(datas)
    return try decodedData(data: jsonDatas)
  }
}

private extension DefaultLocalStorage {
  func fullPathURL(directory: String) -> URL {
    if #available(iOS 16.0, *) {
      return baseURL.appending(path: directory, directoryHint: .isDirectory)
    } else {
      return baseURL.appendingPathComponent(directory, isDirectory: true)
    }
  }
  
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
  
  func decodedData<T: Decodable>(data: Data) throws -> T {
    do {
      let data = try decoder.decode(T.self, from: data)
      return data
    } catch {
      throw StorageError.readError
    }
  }
  
  func save(
    url: URL, 
    fileName: String, 
    data: Encodable
  ) throws {
    do {
      encoder.outputFormatting = .prettyPrinted
      let encodingData = try encoder.encode(data)
      let fileURL = url.appendingPathComponent(fileName)
      fileManager.createFile(atPath: fileURL.path, contents: encodingData)
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
    
    return assembleJSON(combinedData)
  }
  
  func assembleJSON(_ combinedData: [Data]) -> Data {
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
