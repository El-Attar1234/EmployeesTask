//
//  EmployeeFormVC+Extension.swift
//  EmployeesTask
//
//  Created by Ibtikar on 03/12/2022.
//

import UIKit

// MARK: - Extension For UICollectionView Delegation
extension EmployeeFormVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  viewModel.getSkills().count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(with: SkillCell.self, for: indexPath)
        let skill = viewModel.getSkills()[indexPath.item]
        let isSelected = viewModel.isSelected(skill: skill)
        cell.setup(skill: skill, isSelectedSkill: isSelected)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let skill = viewModel.getSkills()[indexPath.item]
        viewModel.addOrDelete(skill: skill)
        collectionView.reloadData()
        }
 
}

// MARK: - Extension For UICollectionView Layout
extension EmployeeFormVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let skill = viewModel.getSkills()[indexPath.item]
        let width = skill.widthOfString(usingFont: .cairoSemiBoldFont(with: 20))
        print("Width \(width)")
        return CGSize(width: width + 16, height: 38)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return   5
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
