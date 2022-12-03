//
//  SearchListVc.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//

import UIKit
import CoreData

class SearchListVc: BaseVC {
    @IBOutlet private weak var emptyView: UIView!
    @IBOutlet private weak var employeesTableView: UITableView!
    
    weak var viewModel: SearchListViewModelProtocol!
    init(viewModel: SearchListViewModelProtocol) {
        super.init(baseViewModel: viewModel)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEmployeeTableView()
        setupInitialUI()
        setupBinding()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    func setupEmployeeTableView() {
        employeesTableView.dataSource = self
        employeesTableView.delegate   = self
        employeesTableView.register(cellType: EmployeeCell.self)
    }
    
    func setupInitialUI() {
        employeesTableView.isHiddenIfNeeded = true
        emptyView.isHiddenIfNeeded = true
    }
    func setupBinding() {
        viewModel.onSuccessFetching = {[weak self] in
            guard let self else { return }
            if self.viewModel.getEmployees().isEmpty {
                self.employeesTableView.isHiddenIfNeeded = true
                self.emptyView.isHiddenIfNeeded = false
            } else {
                self.employeesTableView.reloadData()
                self.employeesTableView.isHiddenIfNeeded = false
                self.emptyView.isHiddenIfNeeded = true
                
                
            }
        }
    }
    
    @IBAction func addEmployeeButtonTapped(_ sender: Any) {
        navigateToForm(mode: .add)
    }
    
    func navigateToForm(mode: FormMode) {
        let employeeformVC = SceneContainer.getEmployeeForm(formMode: mode)
        self.navigationController?.pushViewController(employeeformVC, animated: true)
    }
    
}
