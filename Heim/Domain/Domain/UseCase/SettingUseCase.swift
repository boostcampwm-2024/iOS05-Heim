//
//  SettingUseCase.swift
//  Domain
//
//  Created by 한상진 on 11/7/24.
//

public protocol SettingUseCase: UserUseCase {
  // MARK: - Properties
  var settingRepository: SettingRepository { get }
  var userRepository: UserRepository { get }

  // MARK: - Methods
  func isConnectedCloud() async throws -> Bool
  func updateCloudState(isConnected: Bool) async throws
  func removeCacheData() async throws
  func resetData() async throws
}

public struct DefaultSettingUseCase: SettingUseCase {
  // MARK: - Properties
  public let userRepository: UserRepository
  public let settingRepository: SettingRepository

  // MARK: - Initializer
  public init(
    settingRepository: SettingRepository,
    userRepository: UserRepository
  ) {
    self.settingRepository = settingRepository
    self.userRepository = userRepository
  }

  // MARK: - Methods
  public func isConnectedCloud() async throws -> Bool {
    // TODO: CloudKit 연동 후 구현 예정
//    let state = try await settingRepository.fetchSynchronizationState()
//    return state == .available
    return true
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
