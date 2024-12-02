//
//  UserUseCase.swift
//  Domain
//
//  Created by 한상진 on 12/1/24.
//

import Foundation

public protocol UserUseCase {
  var userRepository: UserRepository { get }
  
  func fetchUserName() async throws -> String
  func updateUserName(to name: String) async throws -> String
}

public extension UserUseCase {
  func fetchUserName() async throws -> String {
    return try await userRepository.fetchUserName()
  }
  
  func updateUserName(to name: String) async throws -> String {
    do {
      try await userRepository.updateUserName(to: name)
      return name
    }
  }
}

public struct DefaultUserUseCase: UserUseCase {
  // MARK: - Properties
  public let userRepository: UserRepository
  
  // MARK: - Initializer
  public init(userRepository: UserRepository) {
    self.userRepository = userRepository
  }
}
