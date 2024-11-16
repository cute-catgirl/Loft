//
//  Status.swift
//  Loft
//
//  Created by Mae on 11/11/24.
//

import Foundation

struct Status: Identifiable {
    var id = UUID()
    let message: String
    let username: String
    let timestamp: String
    let gif: String?
    let isBanned: Bool
    let instance: Instance
    
    init(from array: [Any], instance: Instance) {
        self.message = array[0] as? String ?? ""
        self.username = array[1] as? String ?? ""
        self.timestamp = array[2] as? String ?? ""
        self.gif = array[3] as? String
        self.isBanned = (array[4] as? Int ?? 0) != 0
        self.instance = instance
    }
}
