//
//  EmployeeFormViewModel.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//

import Foundation
import CoreData

protocol EmployeeFormViewModelProtocol: AnyObject, BaseViewModelProtocol {
    // MARK: - ViewLifeCycle
    func viewDidLoad()
    
    // MARK: - Observables
    var onSuccessFetching: (() -> Void)? { get set }
    
    func getSkills() -> [String]
    func isSelected(skill: String) -> Bool
    func addOrDelete(skill: String)
    // func delete(skill: String)
    
}

class EmployeeFormViewModel: BaseViewModel, EmployeeFormViewModelProtocol {
    
    // MARK: - Observables
    var onSuccessFetching: (() -> Void)?
    
    // MARK: - Properties
    lazy var coreDataStack = CoreDataStack(modelName: "EmployeesTask")
    var allSavedSkills: [String] = []
    var selectedSkills: [String] = ["iOS"]
    
    // MARK: - ViewLifeCycle
    func viewDidLoad() {
        importJSONSkillsDataIfNeeded()
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
