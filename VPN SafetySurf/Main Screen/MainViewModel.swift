//
//  MainViewModel.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 01.11.2021.
//

import SwiftUI
import Combine
import NetworkExtension
import CoreLocation

class MainViewModel: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    var isFirstEnter = false
    @Published var isAnimating = false
    @Published var presentingStatus = false
    @Published var activatePrivacyScreen = false
    @Published var status = "START"
    @Published var gradColorOptimalFirst = "64D2FF"
    @Published var gradColorOptimalSecond = "5E5CE6"
    @Published var isOptimal = UserDefaults.standard.bool(forKey: "isAuto") {
        didSet {
            UserDefaults.standard.set(isOptimal, forKey: "isAuto")
            if isOptimal {
                gradColorOptimalFirst = "64D2FF"
                gradColorOptimalSecond = "5E5CE6"
            } else {
                gradColorOptimalFirst = "7C858D"
                gradColorOptimalSecond = "7C858D"
            }
        }
    }
    
    @Published var currentIP = UserDefaults.standard.string(forKey: "currentIP")
    @Published var currentLocation = UserDefaults.standard.string(forKey: "currentLocation")
    @Published var currentPing = UserDefaults.standard.string(forKey: "currentPing")
    @Published var currentStrength = UserDefaults.standard.integer(forKey: "currentStrength")
    
    @Published var firstStrength = { () -> String in
        switch UserDefaults.standard.integer(forKey: "currentStrength") {
        case 1:
            return "32D74B"
        case 2:
            return "FF9F0C"
        default:
            return "FF375F"
        }
    }
    @Published var secondStrength = { () -> String in
        switch UserDefaults.standard.integer(forKey: "currentStrength") {
        case 1:
            return "32D74B"
        case 2:
            return "FF9F0C"
        default:
            return "F5CFD9"
        }
    }
    @Published var thirdStrength = { () -> String in
        switch UserDefaults.standard.integer(forKey: "currentStrength") {
        case 1:
            return "32D74B"
        case 2:
            return "F4E4C8"
        default:
            return "F5CFD9"
        }
    }
    
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        checkFirstEnter()
        
        if VPNLogic().vpnManager.connection.status == .connected {
            presentingStatus = true
        }
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NEVPNStatusDidChange, object: nil, queue: nil, using: { notification in
            let nevpnconn = notification.object as! NEVPNConnection
            let status = nevpnconn.status
            self.checkVPNStatus(status: status)
        })
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.requestWhenInUseAuthorization()
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    func checkVPNStatus(status:NEVPNStatus) {
        switch status {
        case NEVPNStatus.invalid:
            print("NEVPNConnection: Invalid")
            self.status = "START"
            isFirstEnter = true
        case NEVPNStatus.disconnected:
            print("NEVPNConnection: Disconnected")
            self.status = "START"
            presentingStatus = false
            self.isAnimating = false
            if isFirstEnter {
                VPNLogic().connectVPN()
                isFirstEnter = false
            }
        case NEVPNStatus.connecting:
            print("NEVPNConnection: Connecting")
            self.status = "STOP"
            self.isAnimating = true
        case NEVPNStatus.connected:
            print("NEVPNConnection: Connected")
            self.status = "STOP"
            presentingStatus = true
            self.isAnimating = false
        case NEVPNStatus.reasserting:
            print("NEVPNConnection: Reasserting")
        case NEVPNStatus.disconnecting:
            self.status = "DISCONNECTING"
            self.isAnimating = true
            print("NEVPNConnection: Disconnecting")
        @unknown default:
            print("NEVPNConnection: Unknown Error")
        }
    }
    
    private func checkFirstEnter() {
        if !UserDefaults.standard.bool(forKey: "notFirst") {
            selectAutoServer()
            self.activatePrivacyScreen.toggle()
        }
    }
    
    func vpnButtonPressed() {
        if UserDefaults.standard.string(forKey: "currentIP") != nil,
           UserDefaults.standard.string(forKey: "currentID") != nil,
           UserDefaults.standard.string(forKey: "currentUsername") != nil,
           UserDefaults.standard.string(forKey: "currentPass") != nil {
            if UserDefaults.standard.bool(forKey: "isAuto") {
                selectAutoServer()
            }
            vpnAction()
        } else {
            selectAutoServer()
            vpnAction()
        }
        
    }
    
    private func vpnAction() {
        if NEVPNManager.shared().connection.status == .connecting {
            return
        } else if NEVPNManager.shared().connection.status == .connected {
            VPNLogic().disconnectVPN()
        } else {
            VPNLogic().connectVPN()
        }
    }
    
    private func selectAutoServer() {
        let servers = identServers
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
