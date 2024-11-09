//
//  DefaultSettingRepository.swift
//  DataModule
//
//  Created by 한상진 on 11/7/24.
//

import Domain

public final class DefaultSettingRepository: SettingRepository {
  // MARK: - Properties
  
  /* TODO: 추후 구현
   private let networkProvider: NetworkProvidable
   private let localStorage: LocalStorage
   private let cloudStorage: CloudStorage
   */

  // MARK: - Initializer
  
  // TODO: 추후 구현
  public init(
//    networkProvider: NetworkProvidable
  ) {
//    self.networkProvider = networkProvider
  }
  
  public func fetchUserName() async throws -> String {
    // TODO: 추후 구현
    return "임시 테스트 닉네임"
  }
  
  public func removeCacheData() async throws {
    // TODO: 추후 구현
  }
  
  public func resetData() async throws {
    // TODO: 추후 구현
  }
}
