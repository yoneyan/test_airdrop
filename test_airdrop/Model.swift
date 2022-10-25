//
//  Model.swift
//  test_airdrop
//
//  Created by 米田 悠人  on 2022/10/26.
//

import Foundation

struct BackupFile: Codable, Equatable {

  let id: String
  let date: Date
  let name: String
  let data: String?

  init(
    id: String,
    date: Date,
    name: String,
    data: String
  ) {
    self.id = id
    self.date = date
    self.name = name
    self.data = data
  }
}

struct BackupFiles: Decodable {
  let data: [BackupFile]
}
