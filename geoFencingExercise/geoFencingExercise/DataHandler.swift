//
//  DataHandler.swift
//  geoFencingExercise
//
//  Created by vinsol on 12/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import CoreData

class DataHandler {
    
    static let shared = DataHandler()
    private init() {}
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func save(_ pin: CustomPin) -> Bool {
        if checkForExistingEntry(pin.note) {
            return false
        }
        let monitoredRegion = MonitoredRegions(context: context)
        monitoredRegion.latitude = pin.coordinate.latitude
        monitoredRegion.longitude = pin.coordinate.longitude
        monitoredRegion.note = pin.note
        monitoredRegion.radius = pin.radius
        monitoredRegion.entry = pin.monitoredState.rawValue
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
    
    private func checkForExistingEntry(_ note: String) -> Bool {
        let fetchRequest: NSFetchRequest<MonitoredRegions> = MonitoredRegions.fetchRequest()
        let predicate = NSPredicate(format: "note == %@", note)
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            if result.count > 0 {
                return true
            } else {
                return false
            }
        } catch {
            return false
        }
        
    }
    
    func getAllMonitoredRegions(state: MonitoredState?) -> [MonitoredRegions] {
        if let monitoredState = state {
            return getMonitoredRegionsFor(state: monitoredState) + getMonitoredRegionsFor(state: .both)
        } else {
            return getAllMonitoredRegions()
        }
    }
    
    private func getAllMonitoredRegions() -> [MonitoredRegions] {
        let fetchRequest: NSFetchRequest<MonitoredRegions> = MonitoredRegions.fetchRequest()
        
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            return [MonitoredRegions]()
        }
    }
    
    private func getMonitoredRegionsFor(state: MonitoredState) -> [MonitoredRegions] {
        let fetchRequest: NSFetchRequest<MonitoredRegions> = MonitoredRegions.fetchRequest()
        let predicate = NSPredicate(format: "entry == %@", NSNumber(value: state.rawValue))
        fetchRequest.predicate = predicate
        
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            return [MonitoredRegions]()
        }
    }
    
    func delete(_ region: MonitoredRegions?) {
        if let region = region {
            context.delete(region)
            
            do {
                try context.save()
            } catch {
                print("Deletion failure")
            }
        }
    }
    
}
