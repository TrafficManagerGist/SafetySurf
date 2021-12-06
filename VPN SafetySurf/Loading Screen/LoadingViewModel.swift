//
//  LoadingViewModel.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 01.11.2021.
//

import SwiftUI
import Combine
import Firebase

class LoadingViewModel: ObservableObject {
    var activateMainScreen = false
    @Published var isLoaded = false {
        didSet {
            if isLoaded {
                setIdentifiableServers()
                self.activateMainScreen = true
            }
        }
    }
    
    @Published var usage = [String: Double]()
    
    func startLoading() {
        fetchRemoteConfig()
    }
    
    func setIdentifiableServers() {
        identServers.removeAll()
        guard let items = configModel?.servers else { return }
        for config in items {
            if let id = config.id, let location = config.location, let imageLink = config.imageLink, let username = config.username, let pass = config.pass, let ip = config.ip
            {
                let usage = usage[id]
                let region = ServerIdentifiable(strength: getUsage(from: usage), ping: Int(usage ?? 999), location: location, imageLink: imageLink, ip: ip, username: username, pass: pass, serverID: id)
                identServers.append(region)
            } else {
                print("NEMAE")
            }
            
        }
        print("drg: \(items.count)")
        print("FAFAEGGE: \(identServers.count)")
    }
    
    private func usageReqest() {
        guard let config = configModel?.servers else { return }
        let tracker = UsageManager(delegate: self, config: config)
        tracker.pingNext()
    }
    
    func getUsage(from ping: Double?) -> Int {
        guard let ping = ping else { return 0 }
        if ping < 150 {
            return 1
        } else if ping > 150 && ping < 200{
            return 2
        } else {
            return 0
        }
    }
    
    func fetchRemoteConfig(){
        remoteConfig.fetch(withExpirationDuration: 0) { [unowned self] (status, error) in
            guard error == nil else {
                return }
            print("Got the value from Remote Config!")
            remoteConfig.activate()
            setConfig()
        }
    }
    
    func setConfig(){
        let configValue = remoteConfig.configValue(forKey: "serverList").dataValue
        do {
            let result = try JSONDecoder().decode(Config.self, from: configValue)
            configModel = result
            usageReqest()
            isLoaded = true
        } catch {
            print("Failed to get Config from Remote Config")
            isLoaded = true
        }
    }
    
}
