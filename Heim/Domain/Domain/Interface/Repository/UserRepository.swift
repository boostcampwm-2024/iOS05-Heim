//
//  UserRepository.swift
//  Domain
//
//  Created by 한상진 on 12/1/24.
//

public protocol UserRepository {
  func fetchUserName() async throws -> String
  func updateUserName(to name: String) async throws
}
