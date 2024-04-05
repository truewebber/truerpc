//
//  Item.swift
//  TrueRPC
//
//  Created by Aleksey Kish on 05/04/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
