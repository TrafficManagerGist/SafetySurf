//
//  MainViewModel.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 01.11.2021.
//

import SwiftUI
import Combine
import URLImage

class MainViewModel: ObservableObject {
    
    @Published var activatePrivacyScreen = false
    var usage = PassthroughSubject<[Int: Double], Never>()
    
    @Published var shouldChangeUsage = [Int: Double]() {
        didSet {
            usage.send(shouldChangeUsage)
        }
    }
    
    @Published var lastServers = [Image]()
    @Published var lastServersIds = [Int]()
    
    init(usage: [Int: Double]? = nil) {
        guard let usage = usage else { return }
        self.shouldChangeUsage = usage
        checkFirstEnter()
        checkLastServers()
    }
    
    private func checkLastServers() {
        guard let lastServers = UserDefaults.standard.object(forKey: "lastServers") as? [Int] else { return }
        if !lastServers.isEmpty {
            var servers = [Image]()
            var ids = [Int]()
            for lastServer in lastServers {
                if let server = configModel?.servers?[lastServer] {
                    if let link = server.imageLink, let id = server.id {
                        let url = URL(string: link)!
                    }
                }
            }
            self.lastServers = servers
            self.lastServersIds = ids
        }
    }
    
    private func checkFirstEnter() {
        if !UserDefaults.standard.bool(forKey: "notFirst") {
            self.activatePrivacyScreen.toggle()
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
