//
//  Dog+CoreDataProperties.swift
//  SmartPaws
//
//  Created by Sean Laughlin on 5/22/23.
//
//

import Foundation
import CoreData


extension Dog {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Dog> {
        return NSFetchRequest<Dog>(entityName: "Dog")
    }

    @NSManaged public var birthday: Date?
    @NSManaged public var breed: String?
    @NSManaged public var coins: Int16
    @NSManaged public var cosmetics: String?
    @NSManaged public var hapiness: Float
    @NSManaged public var id: UUID?
    @NSManaged public var lastfed: Date?
    @NSManaged public var state: String?
    @NSManaged public var experience: Int16
    @NSManaged public var level: Int16
    @NSManaged public var lasthappy: Date?

}

extension Dog : Identifiable {

}
