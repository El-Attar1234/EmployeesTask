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
    case edit(Employee)
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
    var selectedSkills: [String] = ["iOS"]
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
           
        case .edit(let employee):
            employee.fullName = fullName
            employee.email = email
            employee.photoData = selectedImageData
        }
        coreDataStack.saveContext()
        updatedAddedSuccessfully?(formMode)
       
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
        self.showMessage?("Skills Fetched Successfully", .success)
        self.onSuccessFetching?()
    }
}
