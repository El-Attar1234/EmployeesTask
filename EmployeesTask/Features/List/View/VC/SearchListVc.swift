//
//  SearchListVc.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//

import UIKit

class SearchListVc: BaseVC {
    
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

    }
    
    @IBAction func addEmployeeButtonTapped(_ sender: Any) {
        let employeeformVC = SceneContainer.getEmployeeForm()
        self.navigationController?.pushViewController(employeeformVC, animated: true)
    }
}
