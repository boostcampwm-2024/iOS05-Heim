//
//  Logger.swift
//  Core
//
//  Created by 정지용 on 11/6/24.
//

import os

public enum Logger {
  public static func log(message: String) {
    os_log("\(message)")
  }
}
