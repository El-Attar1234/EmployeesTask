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
    @IBOutlet private weak var searchBar: UITextField!
    
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
        setUpSearchBar()
        setupBinding()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
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
    private func setUpSearchBar() {
        navigationItem.hidesSearchBarWhenScrolling = false
        searchBar.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)
        
    }
    @objc
    func searchTextChanged(_ sender: UITextField) {
        let search = sender.text ?? ""
        viewModel.search(text: search)
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
        viewModel.didsearched = {[weak self] in
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
