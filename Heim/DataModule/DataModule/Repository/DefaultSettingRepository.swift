//
//  DefaultSettingRepository.swift
//  DataModule
//
//  Created by 한상진 on 11/7/24.
//

import Domain

public final class DefaultSettingRepository: SettingRepository {
  // MARK: - Properties
  private let localStorage: DataStorage
  
  // MARK: - Initializer
  public init(localStorage: DataStorage) {
    self.localStorage = localStorage
  }
  
  // MARK: - Methods
  public func removeCacheData() async throws {
    try await localStorage.deleteAll()
  }
  
  // MARK: - 현재 removeCache와 동일 (iCloud 연동 후 수정)
  public func resetData() async throws {
    try await localStorage.deleteAll()
  }
}
