//
//  MonitoredRegions+CoreDataProperties.swift
//  geoFencingExercise
//
//  Created by vinsol on 12/03/20.
//  Copyright © 2020 vinsol. All rights reserved.
//
//

import Foundation
import CoreData


extension MonitoredRegions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MonitoredRegions> {
        return NSFetchRequest<MonitoredRegions>(entityName: "MonitoredRegions")
    }

    @NSManaged public var longitude: Double
    @NSManaged public var latitude: Double
    @NSManaged public var note: String?
    @NSManaged public var radius: Double
    @NSManaged public var entry: Bool

}
