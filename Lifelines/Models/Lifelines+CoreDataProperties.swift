//
//  Lifelines+CoreDataProperties.swift
//  Lifelines
//
//  Created by Jason Puwardi on 04/05/22.
//
//

import Foundation
import CoreData


extension Lifelines {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Lifelines> {
        return NSFetchRequest<Lifelines>(entityName: "Lifelines")
    }

    @NSManaged public var activityDate: Date?
    @NSManaged public var activityGroups: String?
    @NSManaged public var activityTitle: String?
    @NSManaged public var connection: NSSet?

}

// MARK: Generated accessors for connection
extension Lifelines {

    @objc(addConnectionObject:)
    @NSManaged public func addToConnection(_ value: LifelinesTasks)

    @objc(removeConnectionObject:)
    @NSManaged public func removeFromConnection(_ value: LifelinesTasks)

    @objc(addConnection:)
    @NSManaged public func addToConnection(_ values: NSSet)

    @objc(removeConnection:)
    @NSManaged public func removeFromConnection(_ values: NSSet)

}

extension Lifelines : Identifiable {

}
