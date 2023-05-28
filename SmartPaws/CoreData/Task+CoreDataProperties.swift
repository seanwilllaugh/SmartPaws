//
//  Task+CoreDataProperties.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/23/23.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var taskstring: String?
    @NSManaged public var tasktag: String?
    @NSManaged public var datecreated: Date?
    @NSManaged public var duedate: Date?
    @NSManaged public var priority: String?
    @NSManaged public var isCompleted: Bool
}

extension Task : Identifiable {

}
