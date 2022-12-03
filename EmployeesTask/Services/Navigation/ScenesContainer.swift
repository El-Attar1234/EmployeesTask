//
//  ScenesContainer.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//

import UIKit

final class AppNavigationController: UINavigationController {}

final class SceneContainer {
    
    class func embedVCInNavController(_ viewController: UIViewController) -> UIViewController {
        let nav = AppNavigationController(rootViewController: viewController)
        return nav
    }
    
    class func getSearchListVc() -> SearchListVc {
        let viewModel = SearchListViewModel()
        let vc = SearchListVc(viewModel: viewModel)
        return vc
    }
    
    class func getEmployeeForm(formMode: FormMode) -> EmployeeFormVC {
        let viewModel = EmployeeFormViewModel(formMode: formMode)
        let vc = EmployeeFormVC(viewModel: viewModel)
        return vc
    }
}
