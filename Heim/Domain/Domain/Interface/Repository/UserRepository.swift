//
//  UserRepository.swift
//  Domain
//
//  Created by 한상진 on 12/1/24.
//

public protocol UserRepository {
  func fetchUsername() async throws -> String
  func updateUsername(to name: String) async throws
}
