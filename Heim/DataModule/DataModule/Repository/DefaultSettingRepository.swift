//
//  DefaultSettingRepository.swift
//  DataModule
//
//  Created by 한상진 on 11/7/24.
//

import Domain

public final class DefaultSettingRepository: SettingRepository {
  // MARK: - Properties
  private let localStorage: DataStorageModule
  
  /* TODO: 추후 구현
   private let networkProvider: NetworkProvidable
   private let cloudStorage: CloudStorage
   */

  // MARK: - Initializer
  
  // TODO: 추후 구현
  public init(
//    networkProvider: NetworkProvidable
    localStorage: DataStorageModule
  ) {
//    self.networkProvider = networkProvider
    self.localStorage = localStorage
  }
  
  public func fetchUserName() async throws -> String {
    // TODO: 추후 구현
    return "임시 테스트 닉네임"
  }
  
  public func removeCacheData() async throws {
    try await localStorage.deleteAll()
  }
  
  public func resetData() async throws {
    // TODO: 우선 removeCacheData와 동일하게 구현
    try await localStorage.deleteAll()
  }
}
