//
//  StatusViewModel.swift
//  Loft
//
//  Created by Mae on 11/11/24.
//
import SwiftUI

class StatusViewModel: ObservableObject {
    @Published var statuses: [Status] = []
    
    private let instances: [Instance] = [
        Instance(name: "cute-catgirl.github.io", admin: "Mae", endpointFeed: "https://maemoon-lablogingetusers.web.val.run/", statusFeed: "https://maemoon-labloginupdatestatus.web.val.run"),
        Instance(name: "todepond.com", admin: "TodePond", endpointFeed: "https://todepond-lablogingetusers.web.val.run", statusFeed: "https://todepond-labloginupdatestatus.web.val.run"),
        Instance(name: "svenlaa.com", admin: "Svenlaa", endpointFeed: "https://svenlaa-lablogingetusers.web.val.run", statusFeed: "https://svenlaa-labloginupdatestatus.web.val.run"),
        Instance(name: "evolved.systems", admin: "Evol", endpointFeed: "https://evol-lablogingetusers.web.val.run", statusFeed: "https://evol-labloginupdatestatus.web.val.run")
    ]
    
    func fetchStatuses() {
        let dispatchGroup = DispatchGroup()
        var allFetchedStatuses: [Status] = []
        
        for instance in instances {
            guard let url = URL(string: instance.endpointFeed) else { continue }
            
            dispatchGroup.enter()
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                defer { dispatchGroup.leave() }
                
                if let data = data {
                    do {
                        if let jsonArray = try JSONSerialization.jsonObject(with: data, options: []) as? [[Any]] {
                            let parsedStatuses = jsonArray.map { Status(from: $0, instance: instance) }
                            DispatchQueue.main.async {
                                allFetchedStatuses.append(contentsOf: parsedStatuses)
                            }
                        }
                    } catch {
                        print("Error decoding data from \(instance.endpointFeed): \(error)")
                    }
                } else if let error = error {
                    print("Error fetching data from \(instance.endpointFeed): \(error)")
                }
            }.resume()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.statuses = allFetchedStatuses.sorted { status1, status2 in
                status1.timestamp > status2.timestamp
            }
        }
    }
    
    func postStatus(status: String, username: String, password: String, instance: Instance) {
        print("Posting status to instance: \(instance.name)")
        guard let url = URL(string: instance.statusFeed) else {
            print("Invalid URL for instance: \(instance.name)")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body: [String: Any] = [
            "status": status,
            "username": username,
            "password": password
        ]
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: body, options: [])
            request.httpBody = jsonData
            
            print("Sending request to URL: \(url)")
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Response Status Code: \(httpResponse.statusCode)")
                    if httpResponse.statusCode == 200 {
                        print("Successfully posted status.")
                    } else {
                        print("Failed to post status. Status Code: \(httpResponse.statusCode)")
                    }
                }
                
                if let data = data {
                    // Debug print response
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("Response: \(jsonString)")
                    }
                }
            }.resume()
        } catch {
            print("Error serializing JSON: \(error.localizedDescription)")
        }
    }
}