//
//  EmployeeFormVC.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//

import UIKit

class EmployeeFormVC: BaseVC {
    @IBOutlet private weak var skillsCollectionView: UICollectionView!
    
    weak var viewModel: EmployeeFormViewModelProtocol!
    init(viewModel: EmployeeFormViewModelProtocol) {
        super.init(baseViewModel: viewModel)
        self.viewModel = viewModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSkillsCollectionView()
        
        viewModel.viewDidLoad()
    }
    
    func setupSkillsCollectionView() {
        skillsCollectionView.dataSource = self
        skillsCollectionView.delegate   = self
        skillsCollectionView.register(cellType: SkillCell.self)
    }
    func setupBinding() {
        viewModel.onSuccessFetching = {[weak self] in
            guard let self else { return }
            self.skillsCollectionView.reloadData()
        }
    }

}
