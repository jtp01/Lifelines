//
//  LifelinesTasks+CoreDataProperties.swift
//  Lifelines
//
//  Created by Jason Puwardi on 04/05/22.
//
//

import Foundation
import CoreData


extension LifelinesTasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LifelinesTasks> {
        return NSFetchRequest<LifelinesTasks>(entityName: "LifelinesTasks")
    }

    @NSManaged public var isDone: Bool
    @NSManaged public var tasks: String?
    @NSManaged public var lifelines: Lifelines?

}
