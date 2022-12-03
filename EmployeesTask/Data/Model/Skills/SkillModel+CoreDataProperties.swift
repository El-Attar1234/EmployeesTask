//
//  SkillModel+CoreDataProperties.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//
//

import Foundation
import CoreData

extension SkillModel {

    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<SkillModel> {
        return NSFetchRequest<SkillModel>(entityName: "SkillModel")
    }

    @NSManaged public var skill: [String]?

}

extension SkillModel: Identifiable {

}
