//
//  StatusViewModel.swift
//  VPN SafetySurf
//
//  Created by Алексей Трушковский on 01.12.2021.
//

import SwiftUI
import Combine
import NetworkExtension
import SpeedcheckerSDK
import CoreLocation

class StatusViewModel: ObservableObject {
    @Published var downloadArray: [Double] = [0.0]
    @Published var uploadArray: [Double] = [0.0]
    @Published var downloadLabel = "0.0 MB/S"
    @Published var uploadLabel = "0.0 MB/S"
    @Published var timeLabel = " 00:00:00 "
    
    var downloadSpeedArr = [0.0]
    var uploadSpeedArr = [0.0]
    
    private var internetTest: InternetSpeedTest?
    
    var timer = Timer()
    
    init() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.updateValues()
        })
        
        internetTest = InternetSpeedTest(delegate: self)
    }
    
    func startSpeedTest() {
        internetTest?.startTest() { (error) in
            print(error)
        }
    }
    
    func stopSpeedTest() {
        internetTest?.forceFinish({ _ in
            print("Force finished")
        })
    }
    
    func updateValues() {
        if let connectedDate = NEVPNManager.shared().connection.connectedDate {
            timeLabel = Date().offsetFrom(date: connectedDate)
            if timeLabel == " 00:00:01 " {
                startSpeedTest()
            }
        }
    }

    
}

extension Date {
    func offsetFrom(date: Date) -> String {
        let dayHourMinuteSecond: Set<Calendar.Component> = [.day, .hour, .minute, .second]
        let difference = NSCalendar.current.dateComponents(dayHourMinuteSecond, from: date, to: self)
        
        var seconds = "\(difference.second ?? 0)"
        var minutes = "\(difference.minute ?? 0)"
        var hours = "\(difference.hour ?? 0)"
        
        if hours.count == 1 {
            hours = "0\(hours)"
        }
        if minutes.count == 1 {
            minutes = "0\(minutes)"
        }
        if seconds.count == 1 {
            seconds = "0\(seconds)"
        }
        return " " + hours + ":" + minutes + ":" + seconds + " "
    }
}

extension StatusViewModel: InternetSpeedTestDelegate {
    func internetTest(finish error: SpeedTestError) {
        print(error)
    }
    
    func internetTest(finish result: SpeedTestResult) {
        print(result.downloadSpeed.mbps)
        print(result.uploadSpeed.mbps)
        print(result.latencyInMs)
        
    }
    
    func internetTest(received servers: [SpeedTestServer]) {
        //
    }
    
    func internetTest(selected server: SpeedTestServer, latency: Int) {
        //
    }
    
    func internetTestDownloadStart() {
        //
    }
    
    func internetTestDownloadFinish() {
        //
    }
    
    func internetTestDownload(progress: Double, _ speed: SpeedTestSpeed?) {
        guard let speed = speed else { return }
        downloadSpeedArr.append(speed.kbps)
        if downloadSpeedArr.count > 30 {
            downloadSpeedArr.removeFirst()
        }
        guard let maxVal = downloadSpeedArr.max() else { return }
        guard let minVal = downloadSpeedArr.min() else { return }
        
        let aver = (minVal / maxVal)
        guard aver != 0 && !aver.isNaN else { return }
        
        downloadArray.append(aver)
        if downloadArray.count > 30 {
            downloadArray.removeFirst()
        }
        
        print("Download: \(progress) : \(speed.mbps)")
        downloadLabel = "\(speed.descriptionInMbps) MB/S"
        
    }
    
    func internetTestUploadStart() {
        //
    }
    
    func internetTestUploadFinish() {
        //
    }
    
    func internetTestUpload(progress: Double, _ speed: SpeedTestSpeed?) {
        guard let speed = speed else { return }
        uploadSpeedArr.append(speed.kbps)

        if uploadSpeedArr.count > 30 {
            uploadSpeedArr.removeFirst()
        }
        guard let maxVal = uploadSpeedArr.max() else { return }
        guard let minVal = uploadSpeedArr.min() else { return }
        
        let aver = minVal / maxVal
        guard aver != 0 && !aver.isNaN else { return }
        
        uploadArray.append(aver)
        if uploadArray.count > 30 {
            uploadArray.removeFirst()
        }
        
        
        print("Upload: \(progress) : \(speed.mbps)")
        uploadLabel = "\(speed.descriptionInMbps) MB/S"
        
    }
    
    
}
