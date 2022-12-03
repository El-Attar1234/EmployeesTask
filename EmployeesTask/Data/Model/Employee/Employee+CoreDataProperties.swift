//
//  Employee+CoreDataProperties.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//
//

import Foundation
import CoreData

extension Employee {

    @nonobjc
    public class func fetchRequest() -> NSFetchRequest<Employee> {
        return NSFetchRequest<Employee>(entityName: "Employee")
    }

    @NSManaged public var photoData: Data?
    @NSManaged public var fullName: String?
    @NSManaged public var email: String?
    @NSManaged public var skills: [String]?

}

extension Employee: Identifiable {

}
