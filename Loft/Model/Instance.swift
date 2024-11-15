//
//  Instance.swift
//  Loft
//
//  Created by Mae on 11/11/24.
//

import Foundation

struct Instance: Identifiable, Codable, Hashable, Equatable {
    var id = UUID()
    var name: String
    var admin: String
    var endpointFeed: String
    var endpointStatus: String
    var endpointLogin: String
}
