//
//  KeychainTokenStorage.swift
//  DataStorage
//
//  Created by 정지용 on 11/21/24.
//

import DataModule
import Foundation
import Security

// TODO: TokenStorage를 thorwable하게 변경
public struct KeychainTokenStorage: TokenStorage {
  public init() {}
  
  public func save(token: String, attrAccount: String) -> Bool {
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: attrAccount,
      kSecValueData: Data(token.utf8)
    ]
    
    SecItemDelete(query as CFDictionary)
    return SecItemAdd(query as CFDictionary, nil) == errSecSuccess
  }
  
  public func load(attrAccount: String) -> String? {
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: attrAccount,
      kSecReturnData: kCFBooleanTrue as Any,
      kSecMatchLimit: kSecMatchLimitOne
    ]
    
    var dataTypeRef: AnyObject?
    let status = SecItemCopyMatching(query, &dataTypeRef)
    guard status == errSecSuccess,
          let tokenData: Data = dataTypeRef as? Data else { return nil }
    
    return String(data: tokenData, encoding: String.Encoding.utf8)
  }
  
  public func delete(attrAccount: String) -> Bool {
    let query: NSDictionary = [
      kSecClass: kSecClassGenericPassword,
      kSecAttrAccount: attrAccount
    ]
    
    return SecItemDelete(query as CFDictionary) == errSecSuccess
  }
}
