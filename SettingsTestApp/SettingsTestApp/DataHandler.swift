//
//  DataHandler.swift
//  SettingsTestApp
//
//  Created by vinsol on 04/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import Foundation

class DataHandler {
    
    static let shared = DataHandler()
    private struct Constants {
        static let airplaneMode = "airplaneMode"
        static let wifi = "wifi"
        static let bluetooth = "bluetooth"
        static let mobileData = "mobileData"
        static let carrier = "carrier"
        static let notification = "notification"
        static let doNotDisturb = "doNotDisturb"
    }
    
    private func retrieveData<T>(_ key: String, _ type: T.Type) -> T? {
        if let val = UserDefaults.standard.value(forKey: key) as? T {
            return val
        } else {
            return nil
        }
    }
    
    private init() {
        self.airplaneMode = retrieveData(Constants.airplaneMode, Bool.self) ?? false
        if let rawVal = retrieveData(Constants.wifi, Int.self) {
            self.wifi = Enums.Networks(rawValue: rawVal)
        } else {
            self.wifi = Enums.Networks.network1
        }
        self.bluetooth = retrieveData(Constants.bluetooth, Bool.self) ?? false
        self.mobileData = retrieveData(Constants.mobileData, Bool.self) ?? false
        if let rawVal = retrieveData(Constants.carrier, Int.self) {
            self.carrier = Enums.Carrier(rawValue: rawVal)
        } else {
            self.carrier = Enums.Carrier.carrier1
        }
        self.notification = retrieveData(Constants.notification, Bool.self) ?? false
        self.doNotDisturb = retrieveData(Constants.doNotDisturb, Bool.self) ?? false
    }
    
    var airplaneMode: Bool!
    var wifi: Enums.Networks!
    var bluetooth: Bool!
    var mobileData: Bool!
    var carrier: Enums.Carrier!
    var notification: Bool!
    var doNotDisturb: Bool!
    
    static func saveSettings(detail: Enums.Detail) {
        let instance = Self.shared
        switch detail {
        case .airplaneMode:
            UserDefaults.standard.setValue(instance.airplaneMode, forKey: Constants.airplaneMode)
        case .wifi:
            UserDefaults.standard.setValue(instance.wifi.rawValue, forKey: Constants.wifi)
        case .bluetooth:
            UserDefaults.standard.setValue(instance.bluetooth, forKey: Constants.bluetooth)
        case .mobileData:
            UserDefaults.standard.setValue(instance.mobileData, forKey: Constants.mobileData)
        case .carrier:
            UserDefaults.standard.setValue(instance.carrier.rawValue, forKey: Constants.carrier)
        case .notification:
            UserDefaults.standard.setValue(instance.notification, forKey: Constants.notification)
        case .donotDisturb:
            UserDefaults.standard.setValue(instance.doNotDisturb, forKey: Constants.doNotDisturb)
        default:
            break
        }
    }
    
    static func getValueString(detail: Enums.Detail) -> String {
        let instance = Self.shared
        switch detail {
        case .wifi:
            return instance.wifi.description()
        case .bluetooth:
            return onOrOff(instance.bluetooth)
        case .carrier:
            return instance.carrier.description()
        case .mobileData:
            return onOrOff(instance.mobileData)
        default:
            return ""
        }
    }
    
    static func getOnOrOffState(detail: Enums.Detail) -> Bool {
        let instance = Self.shared
        switch detail {
        case .bluetooth:
            return instance.bluetooth
        case .mobileData:
            return instance.mobileData
        case .notification:
            return instance.notification
        case .donotDisturb:
            return instance.doNotDisturb
        default:
            return false
        }
    }
    
    static private func onOrOff(_ val: Bool) -> String {
        return val ? "On" : "Off"
    }
    
}

enum Enums {
    enum Networks: Int, CaseIterable {
        case network1, network2, network3, network4, network5
        
        func description() -> String {
            switch self {
            case .network1:
                return "Network 1"
            case .network2:
                return "Network 2"
            case .network3:
                return "Network 3"
            case .network4:
                return "Network 4"
            case .network5:
                return "Network 5"
            }
        }
        
        static func returnIterator() -> [Networks] {
            return [.network1,.network2,.network3,.network4,.network5]
        }
    }
    
    enum Carrier: Int, CaseIterable {
        case carrier1, carrier2, carrier3, carrier4, carrier5
        
        func description() -> String {
            switch self {
            case .carrier1:
                return "Carrier 1"
            case .carrier2:
                return "Carrier 2"
            case .carrier3:
                return "Carrier 3"
            case .carrier4:
                return "Carrier 4"
            case .carrier5:
                return "Carrier 5"
            }
        }
        
        static func returnIterator() -> [Carrier] {
            return [.carrier1,.carrier2,.carrier3,.carrier4,.carrier5]
        }
    }
    
    enum Detail {
        case airplaneMode, wifi, bluetooth, mobileData, carrier, notification, donotDisturb, general, wallpaper, display
        
        func title() -> String {
            switch self {
            case .airplaneMode:
                return "Airplane Mode"
            case .bluetooth:
                return "Bluetooth"
            case .wifi:
                return "Wi-Fi"
            case .mobileData:
                return "Mobile Data"
            case .carrier:
                return "Carrier"
            case .notification:
                return "Notification"
            case .donotDisturb:
                return "Do Not Disturb"
            case .general:
                return "General"
            case .wallpaper:
                return "Wallpaper"
            case .display:
                return "Display & Brightness"
            }
        }
    }
}
