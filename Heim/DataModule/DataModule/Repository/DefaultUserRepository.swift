//
//  DefaultUserRepository.swift
//  DataModule
//
//  Created by 한상진 on 12/1/24.
//

import Domain

public struct DefaultUserRepository: UserRepository {
  // MARK: - Properties
  private let dataStorage: DataStorage
  
  // MARK: - Initializer
  public init(dataStorage: DataStorage) {
    self.dataStorage = dataStorage
  }
  
  // MARK: - Methods
  public func fetchUserName() async throws -> String {
    return try await dataStorage.readData(directory: "/UserName", fileName: "UserName.json")
  }
  
  public func updateUserName(to name: String) async throws {
    return try await dataStorage.saveData(directory: "/UserName", fileName: "UserName.json", data: name)
  }
}
