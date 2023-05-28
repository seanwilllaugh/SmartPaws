//
//  CompletedTimers+CoreDataProperties.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/17/23.
//
//

import Foundation
import CoreData


extension CompletedTimers {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CompletedTimers> {
        return NSFetchRequest<CompletedTimers>(entityName: "CompletedTimers")
    }

    @NSManaged public var coins: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var length: Float
    @NSManaged public var timestamp: Date?
    @NSManaged public var tag : String?
}

extension CompletedTimers : Identifiable {

}
