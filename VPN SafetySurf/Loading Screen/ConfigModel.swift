//
//  ConfigModel.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 12.11.2021.
//

import Foundation
import ApphudSDK

var configModel: Config?
var identServers = [ServerIdentifiable]()

struct Config: Codable {
    let servers: [Server]?
}

struct Server: Codable {
    let id, location, imageLink, ip, username, pass: String?
}

struct ServerIdentifiable: Identifiable {
    let id = UUID()
    let strength: Int
    let ping: Int
    let location, imageLink, ip, username, pass, serverID: String
}
