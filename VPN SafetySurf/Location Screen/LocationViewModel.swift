//
//  LocationViewModel.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 30.11.2021.
//
import SwiftUI
import Combine

class LocationViewModel: ObservableObject {
    @Published var servers: [ServerIdentifiable]?
    
    init(servers: [ServerIdentifiable]? = nil) {
        if servers != nil {
            self.servers = servers
        }
    }
    
    func saveConfig(config: ServerIdentifiable? = nil) {
        if let config = config {
            UserDefaults.standard.set(false, forKey: "isAuto")
            UserDefaults.standard.set(config.location, forKey: "currentLocation")
            UserDefaults.standard.set(config.serverID, forKey: "currentID")
            UserDefaults.standard.set(config.ip, forKey: "currentIP")
            UserDefaults.standard.set(config.username, forKey: "currentUsername")
            UserDefaults.standard.set(config.pass, forKey: "currentPass")
            UserDefaults.standard.set(config.strength, forKey: "currentStrength")
            UserDefaults.standard.set(config.ping, forKey: "currentPing")
        } else {
            guard let servers = servers else { return }
            guard let first = servers.first else { return }
            var optimalServer = first
            for server in servers {
                if server.ping < optimalServer.ping {
                    optimalServer = server
                }
            }
            UserDefaults.standard.set(optimalServer.location, forKey: "currentLocation")
            UserDefaults.standard.set(optimalServer.serverID, forKey: "currentID")
            UserDefaults.standard.set(optimalServer.ip, forKey: "currentIP")
            UserDefaults.standard.set(optimalServer.username, forKey: "currentUsername")
            UserDefaults.standard.set(optimalServer.pass, forKey: "currentPass")
            UserDefaults.standard.set(optimalServer.strength, forKey: "currentStrength")
            UserDefaults.standard.set(optimalServer.ping, forKey: "currentPing")
        }
    }
    
}

class ImageLoader: ObservableObject {
    var didChange = PassthroughSubject<Data, Never>()
    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}
