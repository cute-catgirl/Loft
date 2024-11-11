//
//  AccountManager.swift
//  Loft
//
//  Created by Mae on 11/11/24.
//

import Foundation

@Observable class AccountManager {
    static let shared = AccountManager()
    
    let instances: [Instance] = [
        Instance(name: "cute-catgirl.github.io", admin: "Mae", endpointFeed: "https://maemoon-lablogingetusers.web.val.run/", statusFeed: "https://maemoon-labloginupdatestatus.web.val.run"),
        Instance(name: "todepond.com", admin: "TodePond", endpointFeed: "https://todepond-lablogingetusers.web.val.run", statusFeed: "https://todepond-labloginupdatestatus.web.val.run"),
        Instance(name: "svenlaa.com", admin: "Svenlaa", endpointFeed: "https://svenlaa-lablogingetusers.web.val.run", statusFeed: "https://svenlaa-labloginupdatestatus.web.val.run"),
        Instance(name: "evolved.systems", admin: "Evol", endpointFeed: "https://evol-lablogingetusers.web.val.run", statusFeed: "https://evol-labloginupdatestatus.web.val.run")
    ]
    
    var username: String {
        get {
            return UserDefaults.standard.string(forKey: "username") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "username")
        }
    }
    
    var password: String {
        get {
            return UserDefaults.standard.string(forKey: "password") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "password")
        }
    }
    
    var selectedInstance: Int {
        get {
            return UserDefaults.standard.integer(forKey: "instance")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "instance")
        }
    }
}
