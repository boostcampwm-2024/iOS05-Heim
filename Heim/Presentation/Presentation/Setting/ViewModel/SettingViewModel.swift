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
  }
  
  let useCase: SettingUseCase
  @Published var state: State
  
  // MARK: - Initializer
  init(useCase: SettingUseCase) {
    self.useCase = useCase
    state = State(userName: "", isConnectedCloud: false)
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
    Task {
      do {
        let userName = try await useCase.fetchUserName()
        state.userName = userName
      } catch(let error) {
        state.userName = ""
        Logger.log(message: "fetchUserName Error: \(error)")
      }
    }
  }
  
  func fetchSynchronizationState() {
    Task {
      do {
        let isConnectedCloud = try await useCase.isConnectedCloud()
        state.isConnectedCloud = isConnectedCloud
      } catch(let error) {
        state.isConnectedCloud = false
        Logger.log(message: "fetchSynchronizationState Error: \(error)")
      }
    }
  }
  
  func updateUserName(_ name: String) {
    Task {
      do {
        try await useCase.updateUserName(name)
        state.userName = name
      } catch(let error) {
        Logger.log(message: "updateUserName Error: \(error)")
      }
    }
  }
  
  func updateSynchronizationState(isConnected: Bool) {
    Task {
      do {
        try await useCase.updateCloudState(isConnected: isConnected)
        state.isConnectedCloud = isConnected 
      } catch(let error) {
        Logger.log(message: "updateSynchronizationState Error: \(error)")
      }
    }
  }
  
  func removeCache() {
    Task {
      do {
        try await useCase.removeCacheData() 
      } catch(let error) {
        Logger.log(message: "removeCache Error: \(error)")
      }
    }
  }
  
  func resetData() {
    Task {
      do {
        try await useCase.resetData() 
      } catch(let error) {
        Logger.log(message: "resetData Error: \(error)")
      }
    }
  }
}
