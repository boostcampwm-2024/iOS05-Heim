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
  
  public func resetData() async throws {
    // TODO: 우선 removeCacheData와 동일하게 구현
    try await localStorage.deleteAll()
  }
}
