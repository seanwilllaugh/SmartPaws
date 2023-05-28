//
//  Tag+CoreDataProperties.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/25/23.
//
//

import Foundation
import CoreData


extension Tag {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tag> {
        return NSFetchRequest<Tag>(entityName: "Tag")
    }

    @NSManaged public var color: String?
    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var createddate: Date?
    @NSManaged public var taskNum: Int16
    @NSManaged public var taskComp: Int16
    @NSManaged public var timerNum: Int16
    @NSManaged public var timerTime: Int16
    @NSManaged public var coinsNum: Int16
    @NSManaged public var expNum: Int16

}

extension Tag : Identifiable {

}
