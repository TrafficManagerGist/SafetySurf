//
//  ConfigModel.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 12.11.2021.
//

import Foundation
import ApphudSDK

var configModel: Config?
var products: [ApphudProduct]?

struct Config: Codable {
    let servers: [Server]?
}

struct Server: Codable {
    let id: Int?
    let location: String?
    let imageLink: String?
    let ip, username, pass, psk: String?
}
