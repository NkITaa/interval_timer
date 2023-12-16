//
//  LockscreenDataModel.swift
//  Runner
//
//  Created by Maurice Nikita Reichert on 14.12.23.
//

import Foundation

struct LockscreenDataModel: Codable, Hashable {
    let time: [Int]
    let sets: Int

    enum CodingKeys: String, CodingKey {
        case time
        case sets
    }
}
