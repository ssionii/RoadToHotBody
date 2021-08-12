//
//  TrainingDetail+CoreDataProperties.swift
//  
//
//  Created by  60117280 on 2021/08/12.
//
//

import Foundation
import CoreData


extension TrainingDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrainingDetail> {
        return NSFetchRequest<TrainingDetail>(entityName: "TrainingDetail")
    }

    @NSManaged public var index: Int64
    @NSManaged public var type: Int16
    @NSManaged public var content: String?
    @NSManaged public var date: Date?
    @NSManaged public var training: Training?

}
