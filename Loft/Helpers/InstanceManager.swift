//
//  InstanceManager.swift
//  Loft
//
//  Created by Mae on 11/15/24.
//

struct InstanceManager {
    static let shared = InstanceManager()
    
    let instances: [Instance] = [
        Instance(name: "todepond.com", admin: "TodePond", endpointFeed: "https://todepond-lablogingetusers.web.val.run", endpointStatus: "https://todepond-labloginupdatestatus.web.val.run", endpointLogin: "https://todepond-lablogin.web.val.run"),
        Instance(name: "svenlaa.com", admin: "Svenlaa", endpointFeed: "https://svenlaa-lablogingetusers.web.val.run", endpointStatus: "https://svenlaa-labloginupdatestatus.web.val.run", endpointLogin: "https://svenlaa-lablogin.web.val.run"),
        Instance(name: "evolved.systems", admin: "Evol", endpointFeed: "https://evol-lablogingetusers.web.val.run", endpointStatus: "https://evol-labloginupdatestatus.web.val.run", endpointLogin: "https://evol-lablogin.web.val.run"),
        Instance(name: "cute-catgirl.github.io", admin: "Mae", endpointFeed: "https://maemoon-lablogingetusers.web.val.run/", endpointStatus: "https://maemoon-labloginupdatestatus.web.val.run", endpointLogin: "https://maemoon-lablogin.web.val.run")
    ]
}
