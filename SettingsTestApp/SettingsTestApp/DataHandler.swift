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
            self.wifi = Enums.Networks.Network1
        }
        self.bluetooth = retrieveData(Constants.bluetooth, Bool.self) ?? false
        self.mobileData = retrieveData(Constants.mobileData, Bool.self) ?? false
        if let rawVal = retrieveData(Constants.carrier, Int.self) {
            self.carrier = Enums.Carrier(rawValue: rawVal)
        } else {
            self.carrier = Enums.Carrier.Carrier1
        }
        self.notification = retrieveData(Constants.notification, Bool.self) ?? false
        self.doNotDisturb = retrieveData(Constants.doNotDisturb, Bool.self) ?? false
    }
    
    private(set) var airplaneMode: Bool!
    private(set) var wifi: Enums.Networks!
    private(set) var bluetooth: Bool!
    private(set) var mobileData: Bool!
    private(set) var carrier: Enums.Carrier!
    private(set) var notification: Bool!
    private(set) var doNotDisturb: Bool!
    
    func saveSettings(detail: Enums.Detail) {
        let instance = Self.shared
        switch detail {
        case .airplaneMode:
            UserDefaults.setValue(instance.airplaneMode, forKey: Constants.airplaneMode)
        case .wifi:
            UserDefaults.setValue(instance.wifi.rawValue, forKey: Constants.wifi)
        case .bluetooth:
            UserDefaults.setValue(instance.bluetooth, forKey: Constants.bluetooth)
        case .mobileData:
            UserDefaults.setValue(instance.mobileData, forKey: Constants.mobileData)
        case .carrier:
            UserDefaults.setValue(instance.carrier.rawValue, forKey: Constants.carrier)
        case .notification:
            UserDefaults.setValue(instance.notification, forKey: Constants.notification)
        case .donotDisturb:
            UserDefaults.setValue(instance.doNotDisturb, forKey: Constants.doNotDisturb)
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
    
    static private func onOrOff(_ val: Bool) -> String {
        return val ? "On" : "Off"
    }
    
}

enum Enums {
    enum Networks: Int {
        case Network1 = 0, Network2, Network3, Network4, Network5
        
        func description() -> String {
            switch self {
            case .Network1:
                return "Network 1"
            case .Network2:
                return "Network 2"
            case .Network3:
                return "Network 3"
            case .Network4:
                return "Network 4"
            case .Network5:
                return "Network 5"
            }
        }
    }
    
    enum Carrier: Int {
        case Carrier1 = 0, Carrier2, Carrier3, Carrier4, Carrier5
        
        func description() -> String {
            switch self {
            case .Carrier1:
                return "Carrier 1"
            case .Carrier2:
                return "Carrier 2"
            case .Carrier3:
                return "Carrier 3"
            case .Carrier4:
                return "Carrier 4"
            case .Carrier5:
                return "Carrier 5"
            }
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