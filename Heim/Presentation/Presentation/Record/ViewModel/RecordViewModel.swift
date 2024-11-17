//
//  RecordViewModel.swift
//  Presentation
//
//  Created by 박성근 on 11/17/24.
//

import Combine
import Core
import Domain

final class RecordViewModel: ViewModel {
  // MARK: - Properties
  enum Action {
    
  }
  
  struct State: Equatable {
    
  }
  
  @Published var state: State
  
  // MARK: - Initializer
  init() {
    self.state = State()
  }
  
  // MARK: - Methods
  func action(_ action: Action) {
    switch action {
      
    }
  }
}

// MARK: - Private Extenion
private extension RecordViewModel {
  
}
