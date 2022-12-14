//
//  EmployeeFormViewModel.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//

import Foundation
import CoreData

enum FormMode {
    case add
    case edit(Employee, Int)
}

protocol EmployeeFormViewModelProtocol: AnyObject, BaseViewModelProtocol {
    // MARK: - ViewLifeCycle
    func viewDidLoad()
    
    // MARK: - Observables
    var onSuccessFetching: (() -> Void)? { get set }
    var updatedAddedSuccessfully: ((FormMode) -> Void)? { get set }
    
    func getFormMode() -> FormMode
    func getSkills() -> [String]
    func isSelected(skill: String) -> Bool
    func addOrDelete(skill: String)
    func setSelected(skills: [String])
    func saveEmployee(fullName: String, email: String)
    var selectedImageData: Data? { get set }
}

class EmployeeFormViewModel: BaseViewModel, EmployeeFormViewModelProtocol {
    
    // MARK: - Observables
    var onSuccessFetching: (() -> Void)?
    var updatedAddedSuccessfully: ((FormMode) -> Void)?
    
    // MARK: - Properties
    let formMode: FormMode
    lazy var coreDataStack = CoreDataStack(modelName: "EmployeesTask")
    var allSavedSkills: [String] = []
    var selectedSkills: [String] = []
    var selectedImageData: Data?
    
    init(formMode: FormMode) {
        self.formMode = formMode
    }
    
    // MARK: - ViewLifeCycle
    func viewDidLoad() {
        importJSONSkillsDataIfNeeded()
    }
    func getFormMode() -> FormMode {
        formMode
    }
    func getSkills() -> [String] {
        allSavedSkills
    }
    
    func setSelected(skills: [String]) {
        selectedSkills = skills
    }
    func isSelected(skill: String) -> Bool {
        selectedSkills.contains(skill)
    }
    func addOrDelete(skill: String) {
        if isSelected(skill: skill) {
            selectedSkills.removeAll { item in
                item == skill
            }
        } else {
            selectedSkills.append(skill)
        }
    }
    func saveEmployee(fullName: String, email: String) {
        switch formMode {
        case .add:
            let employee = Employee(context: coreDataStack.managedContext)
            employee.fullName = fullName
            employee.email = email
            employee.photoData = selectedImageData
            employee.skills = selectedSkills
            coreDataStack.saveContext()
            updatedAddedSuccessfully?(formMode)
        case .edit(let employee, let index):
            employee.fullName = fullName
            employee.email = email
            employee.photoData = selectedImageData
            employee.skills = selectedSkills
            coreDataStack.saveContext()
            updatedAddedSuccessfully?(formMode)
//            print("Data ->>>>> \(employee)")
//            self.fetchSpecificEmployeeAndUpdate(index: index,
//                                                fullName: fullName,
//                                                email: email)
        }
    }
    private func fetchSpecificEmployeeAndUpdate(index: Int, fullName: String, email: String) {
        self.showLoader?()
        let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
        do {
            let savedCount = try coreDataStack.managedContext.count(for: fetchRequest)
            if savedCount != 0 {
                let savedResults = try coreDataStack.managedContext.fetch(fetchRequest)
                let savedEmployee = savedResults[index]
                savedEmployee.fullName = fullName
                savedEmployee.email = email
                savedEmployee.photoData = selectedImageData
                savedEmployee.skills = selectedSkills
                coreDataStack.saveContext()
                self.hideLoader?()
                updatedAddedSuccessfully?(formMode)
            }
            
        } catch let error as NSError {
            self.hideLoader?()
            self.showMessage?("Error fetching: \(error), \(error.userInfo)", .error)
        }
    }
    
}

extension EmployeeFormViewModel {
    private func importJSONSkillsDataIfNeeded() {
        self.showLoader?()
        let fetchRequest: NSFetchRequest<SkillModel> = SkillModel.fetchRequest()
        do {
            let savedCount = try coreDataStack.managedContext.count(for: fetchRequest)
            if savedCount == 0 {
                try? importJSONSKillsData()
            } else {
                let savedResults = try coreDataStack.managedContext.fetch(fetchRequest)[0].skill
                allSavedSkills = savedResults ?? []
                self.fetchedSuccessfully()
            }
            
        } catch let error as NSError {
            self.hideLoader?()
            self.showMessage?("Error fetching: \(error), \(error.userInfo)", .error)
        }
    }
    private func importJSONSKillsData() throws {
        
        if let jsonURL = Bundle.main.url(forResource: "skills", withExtension: "json") {
            let jsonData = try Data(contentsOf: jsonURL)
            let jsonDict = try JSONSerialization.jsonObject(with: jsonData,
                                                            options: [.fragmentsAllowed]) as? [String: [String]]
            let jsonArray = jsonDict?["skills"] as? [String]
            saveSkillsLocally(skills: jsonArray ?? [])
            
        }
    }
    private func saveSkillsLocally(skills: [String]) {
        let skillsModel = SkillModel(context: coreDataStack.managedContext)
        skillsModel.skill = skills
        coreDataStack.saveContext()
        allSavedSkills = skills
        self.fetchedSuccessfully()
    }
    
    private func fetchedSuccessfully() {
        self.hideLoader?()
        self.onSuccessFetching?()
    }
}
