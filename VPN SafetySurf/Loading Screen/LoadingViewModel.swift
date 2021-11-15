//
//  LoadingViewModel.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 01.11.2021.
//

import SwiftUI
import Combine
import ApphudSDK
import Firebase
import AppsFlyerLib

class LoadingViewModel: ObservableObject {
    var activateMainScreen = false
    @Published var isLoaded = false {
        didSet {
            if isLoaded {
                self.activateMainScreen.toggle()
            }
        }
    }
    
    @Published var usage = [Int: Double]()
    
    func startLoading() {
        fetchRemoteConfig()
        Apphud.start(apiKey: "app_uo916tWCkyQM6f7gVGF8qvZEpt5Er9", userID: Apphud.userID(), observerMode: true)
        Apphud.getPaywalls(callback: { (paywalls, Error) in
            let paywall = paywalls?.first(where: { $0.identifier == "safetysurfpaywall" })
            products = paywall?.products
        })
    }
    
    private func usageReqest() {
        guard let config = configModel?.servers else { return }
        let tracker = UsageManager(delegate: self, config: config)
        tracker.pingNext()
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
