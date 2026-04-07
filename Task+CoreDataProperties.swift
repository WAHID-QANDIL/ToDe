//
//  Task+CoreDataProperties.swift
//  ToDe
//
//  Created by Wahid Ali Wahid on 07/04/2026.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var periority: Int64
    @NSManaged public var status: Int64
    @NSManaged public var taskDetails: String?
    @NSManaged public var taskId: Int64
    @NSManaged public var taskTitle: String?

}

extension Task : Identifiable {

}
