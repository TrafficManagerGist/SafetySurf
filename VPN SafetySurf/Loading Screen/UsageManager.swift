//
//  UsageManager.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 01.11.2021.
//

import Foundation
import PlainPing

class UsageManager {
    var items: [Server]
    var delegate: LoadingViewModel
    
    init(delegate: LoadingViewModel, config: [Server]) {
        self.delegate = delegate
        self.items = config
    }
    
    func pingNext() {
        guard items.count > 0 else {
            delegate.isLoaded = true
            return
        }

        let ping = items.removeFirst()
        if let ip = ping.ip, let id = ping.id {
            PlainPing.ping(ip, completionBlock: { (timeElapsed:Double?, error:Error?) in
                if let latency = timeElapsed {
                    self.delegate.usage[id] = latency
                }
                if let error = error {
                    print("error: \(error.localizedDescription)")
                }
                self.pingNext()
            })
        }
    }
    
}
