//
//  Account.swift
//  Loft
//
//  Created by Mae on 11/15/24.
//

import Foundation
import SwiftData

@Model
class Account: Identifiable {
    var id = UUID()
    var username: String
    var password: String
    var instance: Instance
    var isActive: Bool
    
    init(username: String, password: String, instance: Instance, isActive: Bool) {
        self.username = username
        self.password = password
        self.instance = instance
        self.isActive = isActive
    }
}
