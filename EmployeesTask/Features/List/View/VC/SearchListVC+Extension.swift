//
//  SearchListVC+Extension.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//

import UIKit

extension SearchListVc: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getEmployees().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: EmployeeCell.self,
                                                 for: indexPath)
        let employee = viewModel.getEmployees()[indexPath.item]
        cell.setup(employee: employee) { [weak self] in
            guard let self = self else { return }
            self.navigateToForm(mode: .edit(employee, indexPath.item))
        } deleteAction: { [weak self] in
            guard let self = self else { return }
            self.showDeletelert(index: indexPath.item)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return   UITableView.automaticDimension
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
