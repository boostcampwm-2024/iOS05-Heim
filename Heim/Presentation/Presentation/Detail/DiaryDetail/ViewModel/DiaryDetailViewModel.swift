//
//  DiaryDetailViewModel.swift
//  Presentation
//
//  Created by 박성근 on 11/19/24.
//

import Combine
import Core
import Domain

final class DiaryDetailViewModel: ViewModel {
  // MARK: - Properties
  enum Action {
    
  }
  
  struct State: Equatable {
    
  }
  
  // let useCase: DataStorageUseCase
  @Published var state: State
  
  // MARK: - Initializer
  init(
    // useCase: DataStorageUseCase
  ) {
    // self.useCase = useCase
    state = State()
  }
  
  // MARK: - Methods
  func action(_ action: Action) {
    switch action {
      
    }
  }
}

// MARK: - Private Extenion
private extension SettingViewModel {
  
}
