//
//  SearchListVc.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//

import UIKit
import CoreData

class SearchListVc: BaseVC {
    
    weak var viewModel: SearchListViewModelProtocol!
    init(viewModel: SearchListViewModelProtocol) {
        super.init(baseViewModel: viewModel)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    lazy var coreDataStack = CoreDataStack(modelName: "EmployeesTask")
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchSavedEmployee()
    }
    private func fetchSavedEmployee() {
        let fetchRequest: NSFetchRequest<Employee> = Employee.fetchRequest()
        do {
            let savedCount = try coreDataStack.managedContext.count(for: fetchRequest)
            if savedCount == 0 {
                self.showMessage(message: "Empty", type: .error)
            } else {
                let savedResults = try coreDataStack.managedContext.fetch(fetchRequest)
               print(savedResults)
            }
            
        } catch let error as NSError {
            self.hideIndicator()
            self.showMessage(message: "Error fetching: \(error), \(error.userInfo)", type: .error)
        }
    }
    
    @IBAction func addEmployeeButtonTapped(_ sender: Any) {
        let employeeformVC = SceneContainer.getEmployeeForm()
        self.navigationController?.pushViewController(employeeformVC, animated: true)

    }
   
}
