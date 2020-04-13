//
//  MonitoredRegions+CoreDataProperties.swift
//  geoFencingExercise
//
//  Created by vinsol on 10/04/20.
//  Copyright © 2020 vinsol. All rights reserved.
//
//

import Foundation
import CoreData


extension MonitoredRegions {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MonitoredRegions> {
        return NSFetchRequest<MonitoredRegions>(entityName: "MonitoredRegions")
    }

    @NSManaged public var entry: Int64
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var note: String?
    @NSManaged public var radius: Double

}
