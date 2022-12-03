//
//  SearchListViewModel.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//

import Foundation
import CoreData

protocol SearchListViewModelProtocol: AnyObject, BaseViewModelProtocol {
    // MARK: - Observables
    var onSuccessFetching: (() -> Void)? { get set }
    var didsearched: (() -> Void)? { get set }
   
    // MARK: - ViewLifeCycle
    func viewWillAppear()
    
    func getEmployees() -> [Employee]
    func delete(at item: Int)
    func search(text: String)
    
}

class SearchListViewModel: BaseViewModel, SearchListViewModelProtocol {
  
    // MARK: - Observables
    var onSuccessFetching: (() -> Void)?
    var didsearched: (() -> Void)?
    
    // MARK: - Properties
    lazy var coreDataStack = CoreDataStack(modelName: "EmployeesTask")
    var employees: [Employee] = []
    var filteredEmployees: [Employee] = []
    
    func viewWillAppear() {
        fetchSavedEmployees()
    }
    
    func getEmployees() -> [Employee] {
        filteredEmployees
    }
    func delete(at item: Int) {
        let employeeToRemove = filteredEmployees.remove(at: item)
        employees.removeAll { employee in
            employee == employeeToRemove
        }
        coreDataStack.managedContext.delete(employeeToRemove)
        coreDataStack.saveContext()
        
    }
    func search(text: String) {
        if text.isEmpty {
            filteredEmployees = employees
        } else {
            filteredEmployees = filteredEmployees.filter({ employee in
                (employee.fullName ?? "" ).lowercased().contains(text.lowercased())
            })
        }
        didsearched?()
    }
    
}
extension SearchListViewModel {
    private func fetchSavedEmployees() {
        self.showLoader?()
        let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
        do {
            let savedCount = try coreDataStack.managedContext.count(for: fetchRequest)
            if savedCount == 0 {
                self.employees.removeAll()
                self.employees.removeAll()
                self.onSuccessFetching?()
                self.hideLoader?()
            } else {
                let savedResults = try coreDataStack.managedContext.fetch(fetchRequest)
                self.employees = savedResults
                self.filteredEmployees = savedResults
                self.onSuccessFetching?()
                self.hideLoader?()
            }
            
        } catch let error as NSError {
            self.hideLoader?()
            self.showMessage?("Error fetching: \(error), \(error.userInfo)", .error)
        }
    }
}
