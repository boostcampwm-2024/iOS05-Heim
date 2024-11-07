//
//  SettingUseCase.swift
//  Domain
//
//  Created by 한상진 on 11/7/24.
//

public protocol SettingUseCase {

  // MARK: - Properties
  var settingRepository: SettingRepository { get }

  // MARK: - Methods
  func fetchUserName() async throws -> String
  func isConnectedCloud() async throws -> Bool
  func updateUserName(_ name: String) async throws
  func updateCloudState(isConnected: Bool) async throws
  func removeCacheData() async throws
  func resetData() async throws
}

public struct DefaultSettingUseCase: SettingUseCase {

  // MARK: - Properties
  public let settingRepository: SettingRepository

  // MARK: - Initializer
  public init(settingRepository: SettingRepository) {
    self.settingRepository = settingRepository
  }

  // MARK: - Methods
  public func fetchUserName() async throws -> String {
    return try await settingRepository.fetchUserName()
  }
  
  public func isConnectedCloud() async throws -> Bool {
    // TODO: CloudKit 연동 후 구현 예정
//    let state = try await settingRepository.fetchSynchronizationState()
//    return state == .available
    return true
  }
  
  public func updateUserName(_ name: String) async throws {
    // TODO: 유저 이름 업데이트 로직 구현 예정
    // try await settingREpository.updateUserName(name)
  }
  public func updateCloudState(isConnected: Bool) async throws {
    // TODO: iCloud 동기화 상태 업데이트 로직 구현 예정
    // try await settingREpository.updateCloudState(isConnected: isConnected)
  }
  
  public func removeCacheData() async throws {
    try await settingRepository.removeCacheData()
  }
  
  public func resetData() async throws {
    try await settingRepository.resetData()
  }
}
