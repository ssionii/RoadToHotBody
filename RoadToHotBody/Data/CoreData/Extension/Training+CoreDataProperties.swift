//
//  Training+CoreDataProperties.swift
//  
//
//  Created by  60117280 on 2021/08/12.
//
//

import Foundation
import CoreData


extension Training {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Training> {
        return NSFetchRequest<Training>(entityName: "Training")
    }

    @NSManaged public var index: Int64
    @NSManaged public var name: String?

}
