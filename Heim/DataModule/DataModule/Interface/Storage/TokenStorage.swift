//
//  TokenStorage.swift
//  DataModule
//
//  Created by 정지용 on 11/21/24.
//

public protocol TokenStorage {
  func save(token: String, attrAccount: String) -> Bool
  func load(attrAccount: String) -> String?
  func delete(attrAccount: String) -> Bool
}
