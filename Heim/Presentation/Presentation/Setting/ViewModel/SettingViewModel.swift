//
//  SettingViewModel.swift
//  Presentation
//
//  Created by 한상진 on 11/7/24.
//

import Combine
import Core
import Domain

final class SettingViewModel: ViewModel {
  // MARK: - Properties
  enum Action {
    case fetchUserName
    case fetchSynchronizationState
    case updateUserName(_ name: String)
    case updateSynchronizationState(_ isConnected: Bool)
    case removeCache
    case resetData
    
  }
  
  struct State: Equatable {
    var userName: String
    var isConnectedCloud: Bool
    var isErrorPresent: Bool
  }
  
  let useCase: SettingUseCase
  @Published var state: State
  
  // MARK: - Initializer
  init(useCase: SettingUseCase) {
    self.useCase = useCase
    state = State(userName: "", isConnectedCloud: false, isErrorPresent: false)
  }
  
  // MARK: - Methods
  func action(_ action: Action) {
    switch action {
    case .fetchUserName: fetchUserName()
    case .fetchSynchronizationState: fetchSynchronizationState()
    case .updateUserName(let name): updateUserName(name)
    case .updateSynchronizationState(let isConnected): updateSynchronizationState(isConnected: isConnected)
    case .removeCache: removeCache()
    case .resetData: resetData()
    }
  }
}

// MARK: - Private Extenion
private extension SettingViewModel {
  func fetchUserName() {
    Task.detached { [weak self] in
      do {
        self?.state.userName = try await self?.useCase.fetchUserName() ?? "User"
      } catch {
        self?.state.userName = "User"
      }
    }
  }
  
  func fetchSynchronizationState() {
    Task {
      do {
        state.isConnectedCloud = try await useCase.isConnectedCloud()
      } catch(let error) {
        state.isConnectedCloud = false
        Logger.log(message: "fetchSynchronizationState Error: \(error)")
      }
    }
  }
  
  func updateUserName(_ name: String) {
    Task.detached { [weak self] in
      do {
        self?.state.userName = try await self?.useCase.updateUserName(to: name) ?? "User"
      } catch {
        self?.state.isErrorPresent = true
      }
    }
  }
  
  func updateSynchronizationState(isConnected: Bool) {
    Task {
      do {
        try await useCase.updateCloudState(isConnected: isConnected)
        state.isConnectedCloud = isConnected 
      } catch {
        // TODO: iCloud 연동 이후 error 분리
        state.isErrorPresent = true
      }
    }
  }
  
  func removeCache() {
    Task {
      do {
        try await useCase.removeCacheData()
      } catch {
        state.isErrorPresent = true
      }
    }
  }
  
  func resetData() {
    Task {
      do {
        try await useCase.resetData() 
      } catch {
        state.isErrorPresent = true
      }
    }
  }
}
