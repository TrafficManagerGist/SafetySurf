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
    
    @Published var isAnimating = false
    @Published var presentingStatus = false
    @Published var activatePrivacyScreen = false
    @Published var status = "START"
    @Published var gradColorOptimalFirst = "64D2FF"
    @Published var gradColorOptimalSecond = "5E5CE6"
    @Published var isOptimal = UserDefaults.standard.bool(forKey: "isAuto") {
        didSet {
            UserDefaults.standard.set(isOptimal, forKey: "isAuto")
            setOptimalColor()
            selectAutoServer()
            updateParams()
        }
    }
    
    @Published var currentIP = ""
    @Published var currentLocation = ""
    @Published var currentPing = ""
    @Published var currentStrength = 0
    
    func updateParams() {
        if isOptimal != UserDefaults.standard.bool(forKey: "isAuto") {
            isOptimal = UserDefaults.standard.bool(forKey: "isAuto")
        }
        self.currentIP = getCurrentIP()
        self.currentLocation = getCurrentLocation()
        self.currentPing = getCurrentPing()
        self.currentStrength = getCurrentStrength()
    }
    
    private func getCurrentIP() -> String {
        return UserDefaults.standard.string(forKey: "currentIP") ?? ""
    }
    
    private func getCurrentLocation() -> String {
        return UserDefaults.standard.string(forKey: "currentLocation") ?? ""
    }
    
    private func getCurrentPing() -> String {
        return UserDefaults.standard.string(forKey: "currentPing") ?? ""
    }
    
    private func getCurrentStrength() -> Int {
        firstStrength = getFirstStrength()
        secondStrength = getSecondStrength()
        thirdStrength = getThirdStrength()
        return UserDefaults.standard.integer(forKey: "currentStrength")
    }
    
    @Published var firstStrength = "FF375F"
    @Published var secondStrength = "F5CFD9"
    @Published var thirdStrength = "F5CFD9"
    
    private func getFirstStrength() -> String {
        print("First \(UserDefaults.standard.integer(forKey: "currentStrength"))")
        switch UserDefaults.standard.integer(forKey: "currentStrength") {
        case 1:
            return "32D74B"
        case 2:
            return "FF9F0C"
        default:
            return "FF375F"
        }
    }
    
    private func getSecondStrength() -> String {
        print("SECOND \(UserDefaults.standard.integer(forKey: "currentStrength"))")
        switch UserDefaults.standard.integer(forKey: "currentStrength") {
        case 1:
            return "32D74B"
        case 2:
            return "FF9F0C"
        default:
            return "F5CFD9"
        }
    }
    
    private func getThirdStrength() -> String {
        print("THIRD \(UserDefaults.standard.integer(forKey: "currentStrength"))")
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
    
    private func setOptimalColor() {
        if isOptimal {
            gradColorOptimalFirst = "64D2FF"
            gradColorOptimalSecond = "5E5CE6"
        } else {
            gradColorOptimalFirst = "7C858D"
            gradColorOptimalSecond = "7C858D"
        }
    }
    
    
    override init() {
        super.init()
        checkFirstEnter()
        setOptimalColor()
        updateParams()
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
        case NEVPNStatus.disconnected:
            print("NEVPNConnection: Disconnected")
            self.status = "START"
            presentingStatus = false
            self.isAnimating = false
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
            self.status = "STOP"
            self.isAnimating = true
            print("NEVPNConnection: Disconnecting")
        @unknown default:
            print("NEVPNConnection: Unknown Error")
        }
    }
    
    private func checkFirstEnter() {
        if !UserDefaults.standard.bool(forKey: "notFirst") {
            selectAutoServer()
            UserDefaults.standard.set(true, forKey: "isAuto")
            self.activatePrivacyScreen.toggle()
        }
    }
    
    func vpnButtonPressed() {
        if UserDefaults.standard.string(forKey: "currentIP") != nil &&
           UserDefaults.standard.string(forKey: "currentID") != nil &&
           UserDefaults.standard.string(forKey: "currentUsername") != nil &&
           UserDefaults.standard.string(forKey: "currentPass") != nil {
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
        print("SERVER LOC: \(optimalServer.location)")
        UserDefaults.standard.set(optimalServer.location, forKey: "currentLocation")
        UserDefaults.standard.set(optimalServer.serverID, forKey: "currentID")
        UserDefaults.standard.set(optimalServer.ip, forKey: "currentIP")
        UserDefaults.standard.set(optimalServer.username, forKey: "currentUsername")
        UserDefaults.standard.set(optimalServer.pass, forKey: "currentPass")
        UserDefaults.standard.set(optimalServer.strength, forKey: "currentStrength")
        UserDefaults.standard.set(optimalServer.ping, forKey: "currentPing")
    }
    
}
