//
// Created by 米田 悠人  on 2022/10/26.
//

import Foundation

enum Encoder {
  static func jsonData<T: Encodable>(from encodableData: T) -> Data {
    let encoder = JSONEncoder()
    do {
      let data = try encoder.encode(encodableData)
      return data
    } catch {
      fatalError("Encoding failure. error: \(error)")
    }
  }
}
