//
//  SettingRepository.swift
//  Domain
//
//  Created by 한상진 on 11/7/24.
//

public protocol SettingRepository {
  func removeCacheData() async throws
  func resetData() async throws
  
  // TODO: 구현 예정 
  // func fetchSynchronizationState()
  // func updateCloudState(_ isConnected: Bool)
}
