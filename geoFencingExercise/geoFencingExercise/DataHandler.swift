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
        monitoredRegion.entry = (pin.monitoredState == .entry)
        
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
    
    func getAllMonitoredRegions() -> [MonitoredRegions] {
        let fetchRequest: NSFetchRequest<MonitoredRegions> = MonitoredRegions.fetchRequest()
        
        do {
            let result = try context.fetch(fetchRequest)
            return result
        } catch {
            return [MonitoredRegions]()
        }
    }
    
    func delete(_ region: MonitoredRegions) {
        context.delete(region)
    }
    
}
