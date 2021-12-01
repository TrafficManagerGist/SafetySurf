//
//  AppDelegate.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 01.11.2021.
//

import Firebase

var remoteConfig = RemoteConfig.remoteConfig()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
